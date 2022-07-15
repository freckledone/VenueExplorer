//
//  Photo.swift
//  VenueExplorer
//
//  Created by Yuri Gurgenidze on 12/07/2022.
//

import Foundation

struct Photo {
    let prefix: String
    let suffix: String
    let width: Int
    let height: Int
    
    
    var url: URL? {
        return URL(string: prefix + "\(height)x\(width)"+suffix)
    }
}
