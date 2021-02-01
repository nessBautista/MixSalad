//
//  File.swift
//  
//
//  Created by Nestor Hernandez on 30/01/21.
//

import Foundation

public enum UnsplashError: Error {
    case badRequest
    case unauthorized
    case forbiden
    case notfound
    case internalServerError
    case unknown
}
/*
 400 - Bad Request    The request was unacceptable, often due to missing a required parameter
 401 - Unauthorized    Invalid Access Token
 403 - Forbidden    Missing permissions to perform request
 404 - Not Found    The requested resource doesn’t exist
 500, 503 -   Something went wrong on our end
 */
