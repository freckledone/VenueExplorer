//
//  VenueCellItem.swift
//  VenueExplorer
//
//  Created by Yuri Gurgenidze on 12/07/2022.
//

import Foundation

enum VenueListSection {
    case main
}

struct VenueCellItem: Hashable {
    let name: String
    let id: String
    let category: String?
    let distance: String
    let location: String?
    var photo: URL?
}
