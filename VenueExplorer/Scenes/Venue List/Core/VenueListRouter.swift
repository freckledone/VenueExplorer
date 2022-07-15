//
//  VenueListRouter.swift
//  VenueExplorer
//
//  Created by Yuri Gurgenidze on 12/07/2022.
//

import Foundation
import UIKit

protocol VenueListRouterType {
    
}

class VenueListRouter: VenueListRouterType {
    weak var controller: UIViewController?
    
    init(controller: UIViewController) {
        self.controller = controller
    }
}
