//
//  VenueListConfigurator.swift
//  VenueExplorer
//
//  Created by Yuri Gurgenidze on 12/07/2022.
//

import Foundation

protocol VenueListConfiguratorType {
    func configure(_ controller: VenueListViewController)
}

class VenueListConfigurator: VenueListConfiguratorType {
    
    let fetchVenues: FetchVenueRecommendationsUseCaseType
    let fetchPhotos: FetchPhotosUseCaseType
    
    init(
        fetchVenues: FetchVenueRecommendationsUseCaseType,
        fetchPhotos: FetchPhotosUseCaseType
    ) {
        self.fetchVenues = fetchVenues
        self.fetchPhotos = fetchPhotos
    }
    
    func configure(_ controller: VenueListViewController) {
        let viewModel = VenueListViewModel(
            router: VenueListRouter(
                controller: controller
            ),
            fetchVenues: fetchVenues,
            fetchPhotos: fetchPhotos
        )
        controller.viewModel = viewModel
    }
    
    
}
