//
//  UILabel + Extensions.swift
//  VenueExplorer
//
//  Created by Yuri Gurgenidze on 12/07/2022.
//

import Foundation
import UIKit

extension UILabel {
    func setAndShowIfPossible(text: String?) {
        if let labelText = text, !labelText.isEmpty {
            isHidden = false
            self.text = labelText
        }
    }
}
