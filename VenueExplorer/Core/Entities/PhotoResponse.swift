//
//  PhotoResponse.swift
//  VenueExplorer
//
//  Created by Yuri Gurgenidze on 12/07/2022.
//

import Foundation

struct PhotoResponse: Codable {
    let prefix: String
    let suffix: String
    let width: Int
    let height: Int
}
