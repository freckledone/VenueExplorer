//
//  VenuesGateway.swift
//  VenueExplorer
//
//  Created by Yuri Gurgenidze on 12/07/2022.
//

import Foundation
import RxSwift

protocol VenuesGatewayType {
    func fetchVenues(request: FetchPlacesRequest) -> Observable<RecommendedVenuesResponse>
    func fetchPhotos(id: String) -> Observable<[PhotoResponse]>
}

class VenuesGateway: VenuesGatewayType {

    func fetchVenues(request: FetchPlacesRequest) -> Observable<RecommendedVenuesResponse> {
        

        let headers = [
          "Accept": "application/json",
          "Authorization": "fsq39POjUd+l6Kg4qTGibMetP4jwQr4ZSZHpAHkUvAVI0OI="
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://api.foursquare.com/v3/places/search?ll=\(request.latitude),\(request.longitude)&limit=25&radius=\(request.radius)")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        return URLSession.shared.rx
            .data(request: request as URLRequest)
            .map { data in
                let resp = try JSONDecoder().decode(RecommendedVenuesResponse.self, from: data)
                return resp
            }
    }
    
    func fetchPhotos(id: String) -> Observable<[PhotoResponse]> {
        let headers = [
          "Accept": "application/json",
          "Authorization": "fsq39POjUd+l6Kg4qTGibMetP4jwQr4ZSZHpAHkUvAVI0OI="
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://api.foursquare.com/v3/places/\(id)/photos")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        return URLSession.shared.rx
            .data(request: request as URLRequest)
            .map { data in
                let resp = try JSONDecoder().decode([PhotoResponse].self, from: data)
                return resp
            }
    }
    
}
