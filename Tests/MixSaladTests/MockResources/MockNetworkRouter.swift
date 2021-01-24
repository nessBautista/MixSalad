//
//  File.swift
//  
//
//  Created by Nestor Hernandez on 24/01/21.
//

import Foundation
@testable import MixSalad

struct Post: Codable {
    let userId:Int
    let id:Int
    let title:String
    let body:String
}

enum MockEndPoint {
    case get
    case post(userName:String, tweet:String)
    case invalid
}

struct MockClient {
    static var environment: NetworkEnvironment = .staging
    let router = NetworkRouter<MockEndPoint>()
}

extension MockEndPoint: EndPointType {
    var environmentBaseURL: String {
        switch self {
        case .invalid:
            return "https://jsonplaceholderssss.typicode.com/"
        default:
            return "https://jsonplaceholder.typicode.com/"
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: self.environmentBaseURL) else {
            fatalError("Couldn't configure base URL")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .get:
            return "get"
        case .post:
            return "posts"
        case .invalid:
            return "invalid"
        }
    }
    
    var httpMethod: HttpMethod {
        switch self {
        case .get:
            return .get
        case .post:
            return .post
        case .invalid:
            return .get
        }
    }
    var task: HTTPTask {
        switch self {
        case .get:
            return .request
        case .post(let username, let tweet):
            var params:Parameters = ["username":username]
            params["tweet"] = tweet
            return .requestParameters(bodyParameters: params,
                                      bodyEncoding: .jsonEncoding,
                                      urlParameters: nil)
        case .invalid:
            return .request
        }
    }
    
    var headers: HttpHeaders? {
        return nil
    }
}

