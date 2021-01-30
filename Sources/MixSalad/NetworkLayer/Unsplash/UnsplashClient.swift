//
//  File.swift
//  
//
//  Created by Nestor Hernandez on 29/01/21.
//

import Foundation
import Combine

enum UnsplashEndpoit {
    case listPhotos(page:Int, per_page:Int, order_by:String?)
}
extension UnsplashEndpoit: EndPointType {
    var environmentBaseURL: String {
        switch UnsplashClient.environment {
        case .qa:
            return "https://api.unsplash.com/"
        case .staging:
            return "https://api.unsplash.com/"
        case .production:
            return "https://api.unsplash.com/"
        }
    }
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else {
            fatalError("Couldn't configure base URL")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .listPhotos(_, _, _):
            return "photos"
        
        }
    }
    
    var httpMethod: HttpMethod {
        switch self {
        case .listPhotos(_, _, _):
            return .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .listPhotos(let page, let per_page, let order_by):
            var urlParams:Parameters = ["page":page]
            urlParams["per_page"] = per_page
            if let orderBy = order_by {
                urlParams["order_by"] = orderBy
            }
            urlParams["client_id"] = UnsplashClient.UnsplashAPIKey
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: urlParams)
        }
    }
    
    var headers: HttpHeaders? {
        return ["Authorization":"Client-ID \(UnsplashClient.UnsplashAPIKey)"]
    }
    
    
}

class UnsplashClient: UnsplashProtocol {
    static var environment: NetworkEnvironment = .staging
    static let UnsplashAPIKey = "TVaxbYcLeYTX5HSSlOASUAuZyQ_StH1sfsxehsWL_Oc"
    typealias getPhotosResponse = (photos:[UnsplashPhoto]?, errorDescription:String?)
    let router = NetworkRouter<UnsplashEndpoit>()
    
    func listPhotos(page: Int,
                    perPage:Int,
                    orderBy: UnsplashOrderBy) -> AnyPublisher<[UnsplashPhoto]?, UnsplashError> {
        router.request(.listPhotos(page: page,
                                   per_page: 10,
                                   order_by: orderBy.rawValue))
            .mapError({ (error) -> UnsplashError in
                return UnsplashError.unknow
            })
            .map { (data) in
                let photos = try? JSONDecoder().decode([UnsplashPhoto].self, from: data)
                return photos
            }.eraseToAnyPublisher()
    }
}
