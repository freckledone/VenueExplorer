//
//  RecommendedVenuesResponse.swift
//  VenueExplorer
//
//  Created by Yuri Gurgenidze on 12/07/2022.
//

import Foundation

struct RecommendedVenuesResponse: Codable {
    
    let results: [Result]
    
    struct Result: Codable {
        let fsqID: String
        let categories: [Category]
        let chains: [Chain]
        let distance: Int
        let link: String
        let name: String
        let location: Location

        enum CodingKeys: String, CodingKey {
            case fsqID = "fsq_id"
            case categories, chains, distance, link, location, name
        }
    }
    
    struct Category: Codable {
        let id: Int
        let name: String
        let icon: Icon
    }
    
    struct Icon: Codable {
        let iconPrefix: String
        let suffix: String

        enum CodingKeys: String, CodingKey {
            case iconPrefix = "prefix"
            case suffix
        }
    }
    
    struct Chain: Codable {
        let id, name: String
    }
    
    struct Location: Codable {
        let formattedAddress: String
        let country: String
        let locality: String?

        enum CodingKeys: String, CodingKey {
            case locality, country
            case formattedAddress = "formatted_address"
        }
    }
    
    
}


