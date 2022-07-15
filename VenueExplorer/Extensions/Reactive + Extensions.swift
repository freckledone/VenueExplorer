//
//  Reactive + Extensions.swift
//  VenueExplorer
//
//  Created by Yuri Gurgenidze on 13/07/2022.
//

import Foundation
import RxSwift

extension Reactive where Base: UIViewController {
    var showError: Binder<Error> {
        return Binder(self.base) { vc, error in
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            vc.present(alert, animated: true, completion: nil)
        }
    }
}
