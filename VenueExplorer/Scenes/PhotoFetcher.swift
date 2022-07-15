//
//  PhotoFetcher.swift
//  VenueExplorer
//
//  Created by Yuri Gurgenidze on 15/07/2022.
//

import Foundation
import RxSwift

class PhotoFetcher {
    
    var photos = PublishSubject<Photo>()
    
    private var fetchPhoto: FetchPhotosUseCaseType
    
    private var storage = [Int: Photo]()
    private let disposeBag = DisposeBag()
    
    init(fetchPhoto: FetchPhotosUseCaseType, photoIds: [String]) {
        self.fetchPhoto = fetchPhoto
        fetch(for: photoIds)
    }
    
    private func fetch(for ids: [String]) {
        for id in ids {
           
            fetchPhoto
                .fetch(for: id)
                .compactMap({
                    print("AAAAAAA PHOTO CAME")
                    return $0.first
                })
                .bind(to: photos)
                .disposed(by: disposeBag)
        }
    }
    
    
    
    
}

