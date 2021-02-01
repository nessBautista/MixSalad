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
    /// Gets a list of photos with  Parameters
    /// - Parameter page: number of page
    /// - Parameter perPage: Items per page
    /// - Parameter orderBy: sorted by oldest, latest and popular (default is latest)
    func listPhotos(page: Int,
                    perPage:Int,
                    orderBy: UnsplashOrderBy?) -> AnyPublisher<[UnsplashPhoto]?, UnsplashError>
    
    /// Gets the Photo detail
    /// - Parameter id: ID of the photo
    func getAPhoto(id: String) -> AnyPublisher<UnsplashPhoto, UnsplashError>
    
    /// Gets a random photo
    func getARandomPhoto() -> AnyPublisher<UnsplashPhoto, UnsplashError>
    
    /// Retrieve total number of downloads, views and likes of a single photo,
    /// as well as the historical breakdown of these stats in a specific timeframe (default is 30 days).
    /// - Parameter id: The public id of the photo. Required
    /// - Parameter resolution: The frequency of the stats. (Optional; default: “days”)
    /// - Parameter quantity: TThe amount of for each stat. (Optional; default: 30)
    func getAPhotoStatistics(id: Int, resolution: String? , quantity: Int?)
    
//    func trackAPhotoDownload()
//    func updateAPhoto()
//    func likeAPhoto()
//    func unlikeAPhoto()
}
