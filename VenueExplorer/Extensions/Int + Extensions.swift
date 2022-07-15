//
//  Int + Extensions.swift
//  VenueExplorer
//
//  Created by Yuri Gurgenidze on 12/07/2022.
//

import Foundation

extension Int {
    var formattedDistance: String {
        if self > 1000 {
            return "\(Double(self / 1000))km"
        } else {
            return "\(self)m"
        }
    }
}
