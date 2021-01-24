//
//  File.swift
//  
//
//  Created by Nestor Hernandez on 24/01/21.
//

import Foundation
import XCTest
import Combine
@testable import MixSalad

final class NetworkLayerTestCase: XCTestCase {
    var subscriptions = Set<AnyCancellable>()
    func testMockEndpoint() {
        
        //Test basic call
        let client = MockClient()
        let expect = expectation(description: "Test Mock Client")
        client.router.request(.get)
            .sink { (completion) in
                expect.fulfill()
                print(completion)
            } receiveValue: { (data) in
                print(data)
            }.store(in: &subscriptions)
        waitForExpectations(timeout: 5, handler: nil)

    }
    
    func testErrorMockEndpoint(){
        //Test basic call
        let client = MockClient()
        let expect = expectation(description: "Test Mock Client")
        client.router.request(.invalid)
            .sink { (completion) in
                expect.fulfill()
                print(completion)
            } receiveValue: { (data) in
                print(data)
            }.store(in: &subscriptions)
        waitForExpectations(timeout: 5, handler: nil)
    }
}

