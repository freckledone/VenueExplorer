//
//  FetchVenueRecommendationsUseCase.swift
//  VenueExplorer
//
//  Created by Yuri Gurgenidze on 12/07/2022.
//

import Foundation
import RxSwift

protocol FetchVenueRecommendationsUseCaseType {
    func display(request: FetchPlacesRequest) -> Observable<[Venue]>
}

class FetchVenueRecommendationsUseCase: FetchVenueRecommendationsUseCaseType {
    private let gateway: VenuesGatewayType
    
    init(gateway: VenuesGatewayType) {
        self.gateway = gateway
    }
    
    func display(request: FetchPlacesRequest) -> Observable<[Venue]> {
        gateway.fetchVenues(request: request).map { resp in
            resp.results.map {
                Venue(
                    id: $0.fsqID,
                    name: $0.name,
                    distance: $0.distance,
                    categories: $0.categories.map({VenueCategory(name: $0.name)}),
                    location: VenueLocation(
                        formattedAddress: $0.location.formattedAddress,
                        locality: $0.location.locality,
                        country: $0.location.country
                    )
                )
            }
        }
    }
    
}
