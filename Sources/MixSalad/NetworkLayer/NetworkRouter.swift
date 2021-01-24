//
//  File.swift
//  
//
//  Created by Nestor Hernandez on 24/01/21.
//

import Foundation
import Combine
typealias Output = URLSession.DataTaskPublisher.Output
typealias Failure = NetworkError

protocol NetworkRouterProtocol:class {
    associatedtype EndPoint:EndPointType
    func request(_ route: EndPoint) -> AnyPublisher<Data, NetworkError>
    func cancel()
}

class NetworkRouter<EndPoint:EndPointType>: NetworkRouterProtocol {
   
    func request(_ route: EndPoint) -> AnyPublisher<Data, NetworkError> {
        let session = URLSession.shared
        do {
            let request = try self.buildRequest(from: route)
            return session.dataTaskPublisher(for: request)
                .mapError { (error) -> NetworkError in
                    switch error.code {
                    case URLError.cannotFindHost:
                        return NetworkError.unknown
                    default:
                        return NetworkError.unknown
                    }
                }
                .flatMap({ (output) -> AnyPublisher<Data, NetworkError> in
                    var result: Result<Data, NetworkError> = .failure(NetworkError.unknown)
                    guard let response = output.response as? HTTPURLResponse else {
                        return result.publisher.eraseToAnyPublisher()
                    }
                    guard response.statusCode == 200 else {
                        return result.publisher.eraseToAnyPublisher()
                    }                 
                    result = .success(output.data)
                    return result.publisher.eraseToAnyPublisher()
                })
                .eraseToAnyPublisher()
        } catch {
            let result: Result<Data, NetworkError> = .failure(NetworkError.unknown)
            return result.publisher.eraseToAnyPublisher()
        }
    }
    
    func cancel() {
        
    }
    
    fileprivate func buildRequest(from route: EndPoint) throws -> URLRequest {
        
        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 10.0)
        
        request.httpMethod = route.httpMethod.rawValue
        do {
            switch route.task {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            case .requestParameters(let bodyParameters,
                                    let bodyEncoding,
                                    let urlParameters):
                
                try self.configureParameters(bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             request: &request)
                
            case .requestParametersAndHeaders(let bodyParameters,
                                              let bodyEncoding,
                                              let urlParameters,
                                              let additionalHeaders):
                
                self.addAdditionalHeaders(additionalHeaders, request: &request)
                try self.configureParameters(bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             request: &request)
            case .download:
                break
            }
            return request
        } catch {
            throw error
        }
    }
    
    fileprivate func configureParameters(bodyParameters: Parameters?,
                                         bodyEncoding: ParameterEncoding,
                                         urlParameters: Parameters?,
                                         request: inout URLRequest) throws {
        do {
            try bodyEncoding.encode(urlRequest: &request,
                                    bodyParameters: bodyParameters, urlParameters: urlParameters)
        } catch {
            throw error
        }
    }
    
    
    fileprivate func addAdditionalHeaders(_ additionalHeaders:HttpHeaders?, request: inout URLRequest){
        guard let headers = additionalHeaders else {return}
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
}

/// Combine adaptation of URLSession
extension URLSession {
    func dataPublisher(with request: URLRequest) -> AnyPublisher<URLSession.DataTaskPublisher.Output, URLSession.DataTaskPublisher.Failure> {
        dataTaskPublisher(for: request).eraseToAnyPublisher()
    }
}

