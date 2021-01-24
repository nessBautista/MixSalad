//
//  File.swift
//  
//
//  Created by Nestor Hernandez on 24/01/21.
//

import Foundation

/**
 Helps to obtain a more abstract representation of the network operation about to request: Fetching, Posting, downloading, Uploading.
*/
protocol EndPointType {
    
    var baseURL:URL {get}
    var path: String {get}
    var httpMethod: HttpMethod {get}
    var task:HTTPTask {get}
    var headers: HttpHeaders? {get}
}

public typealias HttpHeaders = [String:String]

/**
  This enum classifies the type of request from simple to complex

 *Values*

 `request`  Just a basic request

 `requestParameters`   A request that needs a http body like a post method

 `requestParametersAndHeaders`   Request that needs parameters and headers
*/
public enum HTTPTask {
    case request
    
    case requestParameters(bodyParameters:Parameters?,
        bodyEncoding: ParameterEncoding,
        urlParameters:Parameters?)
    
    case requestParametersAndHeaders(bodyParameters:Parameters,
        bodyEncoding: ParameterEncoding,
        urlParameters:Parameters?,
        additionalHeaders:HttpHeaders?)
    
    //case download, upload...
    case download
}

/**
 HTTP method type classification with String type
 */
public enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}
