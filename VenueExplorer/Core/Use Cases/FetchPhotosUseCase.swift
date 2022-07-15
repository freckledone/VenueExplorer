//
//  FetchPhotosUseCase.swift
//  VenueExplorer
//
//  Created by Yuri Gurgenidze on 12/07/2022.
//

import Foundation
import RxSwift

protocol FetchPhotosUseCaseType: AnyObject {
    func fetch(for id: String) -> Observable<[Photo]>
}

class FetchPhotosUseCase: FetchPhotosUseCaseType {
    
    private let gateway: VenuesGatewayType
    
    init(gateway: VenuesGatewayType) {
        self.gateway = gateway
    }
    
    func fetch(for id: String) -> Observable<[Photo]> {
        gateway.fetchPhotos(id: id)
            .map { resp in
                print("AAAAAAA usecase")
                return resp.map({
                    Photo(
                        prefix: $0.prefix,
                        suffix: $0.suffix,
                        width: $0.width,
                        height: $0.height
                    )
                })
            }
    }
    
    
}
