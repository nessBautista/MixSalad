//
//  File.swift
//  
//
//  Created by Nestor Hernandez on 29/01/21.
//

import Foundation
import Combine
public enum UnsplashOrderBy: String {
    case latest
    case oldest
    case popular
}
protocol UnsplashProtocol {
    func listPhotos(page: Int,
                    perPage:Int,
                    orderBy: UnsplashOrderBy) -> AnyPublisher<[UnsplashPhoto]?, UnsplashError>
//    func getAPhoto()
//    func getARandomPhoto()
//    func getAPhotoStatistics()
//    func trackAPhotoDownload()
//    func updateAPhoto()
//    func likeAPhoto()
//    func unlikeAPhoto()
}
