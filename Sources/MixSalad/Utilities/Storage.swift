//
//  File.swift
//  
//
//  Created by Nestor Hernandez on 24/01/21.
//

import Foundation

enum StorageError: Error {
    case diskWritingError(String)
    case emptyKey(String)
    case deletionError(String)
}

public class Storage <Value:Codable> {
    private let dateProvider: () -> Date
    private var content:[String:Packet] = [:]
    private var lifetime: TimeInterval
    
    init(dateProvider: @escaping () -> Date = Date.init,
        lifetime: TimeInterval = 12 * 60 * 60) {
        self.dateProvider = dateProvider
        self.lifetime = lifetime
    }
    
    //Appends a key to the TempDirectory's path url. Then reads its content
    private func writeToDisk(key:String, packet:Packet) throws {
        guard key.isEmpty == false else {
            throw StorageError.emptyKey("Invalid Key")
        }
        //Construct an URL with the Key of the value to be storaged
        let packetURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("\(key)")
        print(packetURL)
        
        //serialize data
        if let dataToWrite = try? JSONEncoder().encode(packet) {
            do {
                try dataToWrite.write(to: packetURL, options: [.atomic])
            }catch{
                throw StorageError.diskWritingError("\(error.localizedDescription)")
            }
        }
        
    }
    //Appends a key to the TempDirectory's path url. Then writes to it
    func readFromDisk(_ key: String) -> Packet? {
        let packetUrl = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("\(key)")
        if let data = try? Data(contentsOf: packetUrl), let packet = try? JSONDecoder().decode(Packet.self, from: data) {
            print("returned packet with content:\(packet.value) and expiration date:\(packet.expirationDate)")
            return packet
        }
        return nil

    }
    
    //Appends a key to the TempDirectory's path url. Then delete it
    func deleteFromDisk(_ key:String) throws  {
        let packetUrl = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent("\(key)")
        do {
            try FileManager.default.removeItem(at: packetUrl)
        } catch {
            throw StorageError.deletionError("Error occurred when deleting a file")
        }
    }
    
    /// Packet: This pairs the value to be stored with an expiration date
    final class Packet {
        let value:Value
        let expirationDate: Date

            init(value: Value, expirationDate: Date) {
                self.value = value
                self.expirationDate = expirationDate
            }
    }
    
    /// Associates an expiration date by creating a Packet instance
    private func insert(_ value: Value, forkey key:String) {
        let date = dateProvider().addingTimeInterval(lifetime)
        let packet = Packet(value: value, expirationDate: date)
        self.content[key] = packet
        print("inserting-> \(packet) for key:\(key)")
        do {
            try self.writeToDisk(key: key, packet: packet)
        }catch {
            print(error)
        }
    }
    /// Extracts an stored value only if lifeTime is not expired.
    private func value(forKey key: String) -> Value? {
        //Check if value exist
        guard let packet = self.readFromDisk(key) else {
            return nil
        }
        //Evict from disk after expirationDate
        guard dateProvider() < packet.expirationDate else {
            print("---THIS PACKET HAS EXPIRED")
            removeValue(forKey: key)
            return nil
        }
        print("value forKey:\(packet.value)")
        return packet.value
    }
    
    /// Removes value from TempDirectory for a given key
    private func removeValue(forKey key: String) {
        print("removeValue for key:\(key)")
        do {
            try self.deleteFromDisk(key)
        } catch {
            print("There was an error when deleting packet")
            print(error)
        }
     }
}

///Subscripts
extension Storage {
    subscript(key:String) -> Value? {
        get {return value(forKey: key)}
        set{
            //Check for empty keys
            guard key.isEmpty == false else {
                return
            }
            
            //when value is nil, it means delete operation
            guard let value = newValue else {
                content[key] = nil
                removeValue(forKey: key)
                return
            }
            insert(value, forkey: key)
        }
    }
}

///CODABLE
extension Storage.Packet: Codable where Value:Codable{}
