//
//  Venue.swift
//  VenueExplorer
//
//  Created by Yuri Gurgenidze on 12/07/2022.
//

import Foundation

struct Venue {
    let id: String
    let name: String
    let distance: Int
    let categories: [VenueCategory]
    let location: VenueLocation
}

struct VenueLocation {
    let formattedAddress: String
    let locality: String?
    let country: String
}

struct VenueCategory {
    let name: String
}
