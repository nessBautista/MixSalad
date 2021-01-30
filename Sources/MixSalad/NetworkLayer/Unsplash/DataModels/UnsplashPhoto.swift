//
//  File.swift
//  
//
//  Created by Nestor Hernandez on 29/01/21.
//

import Foundation
public enum UnsplashError: Error {
    case unknow
}
struct UnsplashTag: Codable {
    let title: String
}

struct UnsplashURLS: Codable {
    let raw: String?
    let full: String?
    let regular: String?
    let small: String?
    let thumb: String?
}
struct UnsplashLinks: Codable {
    //let self: String
    let html: String?
    let photos: String?
    let likes: String?
    let portfolio: String?
    let download: String?
    let download_location: String?
}
struct UnsplashPosition: Codable {
    let latitude: Double
    let longitude: Double
}
struct UnsplashLocation: Codable {
    let city: String
    let country: String
    let position: UnsplashPosition
}

struct UnsplashUser: Codable {
    let id: String
    let updated_at: String
    let username: String
    let name: String
    let portfolio_url: String
    let bio: String
    let location: String
    let total_likes: Int
    let total_photos: Int
    let total_collections: Int
    let links: [UnsplashLinks]?
}

struct UnsplashPhoto: Codable {
    let id: String
    let description: String
    let created_at: String
    let updated_at: String
    let width: Int
    let height: Int
    let color: String
    let blur_hash: String
    let downloads: Int
    let likes: Int
    let liked_by_user: Bool
}
