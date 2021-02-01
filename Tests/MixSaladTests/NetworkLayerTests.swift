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
    var tempPhotoId: String = "v9FQR4tbIq8"
    var subscriptions = Set<AnyCancellable>()
    let client = UnsplashClient()
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
    
    func testErrorMockEndpoint() {
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
    
    func testUnsplashListPhotos() {
        
        let expect = expectation(description: "Testing UnsplashClient->ListPhotos")
        client.listPhotos(page: 1,
                          perPage: 10,
                          orderBy: .latest)
            .sink { (completion) in
                expect.fulfill()
            } receiveValue: { (photos) in
                XCTAssertNotNil(photos)
                if let photoId = photos?.first?.id {
                    self.tempPhotoId = photoId
                }
            }.store(in: &subscriptions)
            
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testUnsplashGetPhoto() {
        guard !self.tempPhotoId.isEmpty else {
            XCTFail("There was no a valid ID to get a Photo")
            return
        }
        let expect = expectation(description: "Testing UnsplashClient->getPhoto")
        client.getAPhoto(id: self.tempPhotoId)
            .sink { (completion) in
                expect.fulfill()
            } receiveValue: { (photo) in
                print(photo)
                XCTAssertNotNil(photo)
            }.store(in: &subscriptions)

        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testUnsplashGetRandomPhoto() {
        let expect = expectation(description: "Testing UnsplashClient->getARandomPhoto")
        client.getARandomPhoto()
            .sink { (completion) in
                expect.fulfill()
            } receiveValue: { (photo) in
                print(photo)
                XCTAssertNotNil(photo)
            }.store(in: &subscriptions)

        waitForExpectations(timeout: 5, handler: nil)
    }
}

