//
//  VenueListViewModel.swift
//  VenueExplorer
//
//  Created by Yuri Gurgenidze on 12/07/2022.
//

import Foundation
import RxSwift
import CoreLocation

protocol VenueListViewModelType {
    var radiusDataSource: Observable<[String]> { get }
    var showError: Observable<Error> { get }
    var showEmptyView: Observable<Bool> { get }
    var showLoader: Observable<Bool> { get }
    var showRadius: Observable<Int> { get }
    var radiusSelected: PublishSubject<Int> { get }
    var configureTableView: PublishSubject<UITableView> { get }
}

class VenueListViewModel: NSObject, VenueListViewModelType {
    
    var showError: Observable<Error>
    var showEmptyView: Observable<Bool>
    var showLoader: Observable<Bool>
    var radiusDataSource: Observable<[String]>
    var showRadius: Observable<Int>
    
    let radiusSelected = PublishSubject<Int>()
    let radiusPickerTapped = PublishSubject<Void>()
    let configureTableView = PublishSubject<UITableView>()
    
    var dataSource: UITableViewDiffableDataSource<VenueListSection, VenueCellItem>!
    
    private let showErrorReplaySubject = ReplaySubject<Error>.create(bufferSize: 1)
    private let showEmptyViewReplaySubject = ReplaySubject<Bool>.create(bufferSize: 1)
    private let showLoaderReplaySubject = ReplaySubject<Bool>.create(bufferSize: 1)
    private let radiusDataSourceReplaySubject = ReplaySubject<[String]>.create(bufferSize: 1)
    private let showRadiusReplaySubject = ReplaySubject<Int>.create(bufferSize: 1)
    
    
    
    
    var router: VenueListRouterType
    var fetchVenues: FetchVenueRecommendationsUseCaseType
    var fetchPhotos: FetchPhotosUseCaseType
    let locationManager = CLLocationManager()
    private let radiuses = [10, 100, 1000, 10000, 100000]
    private let disposeBag = DisposeBag()
    private var venues = [Venue]()
    private var venueCellItems = [VenueCellItem]()
    private var indexMap = [String: Int]()
    
    init(
        router: VenueListRouterType,
        fetchVenues: FetchVenueRecommendationsUseCaseType,
        fetchPhotos: FetchPhotosUseCaseType
    ) {
        self.router = router
        self.showError = showErrorReplaySubject
        self.showEmptyView = showEmptyViewReplaySubject
        self.showRadius = showRadiusReplaySubject
        self.showLoader = showLoaderReplaySubject
        self.radiusDataSource = radiusDataSourceReplaySubject
        self.fetchVenues = fetchVenues
        self.fetchPhotos = fetchPhotos
        super.init()
        requestLocationServices()
        bindModels()
        emitRadiuses()
    }
    
    private func bindModels() {
        radiusSelected
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: radiusSelected(at:)
            ).disposed(by: disposeBag)
        
        configureTableView
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: configureDataSource(for:))
            .disposed(by: disposeBag)
    }
    
    private func configureDataSource(for tableView: UITableView) {
        dataSource = UITableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: { tableView, indexPath, itemIdentifier in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: VenueTableViewCell.self)) as? VenueTableViewCell
                else {
                    return UITableViewCell()
                }
                cell.configure(with: itemIdentifier)
                return cell
            })
    }
    
    private func updateDataSource(animated: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<VenueListSection, VenueCellItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(venueCellItems)
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
    
    private func radiusSelected(at index: Int) {
        guard let coordinates = locationManager.location?.coordinate else {
            self.showEmptyViewReplaySubject.onNext(true)
            return
        }
        let radius = radiuses[index]
        showRadiusReplaySubject.onNext(radius)
        fetchRecommendedVenues(
            requestItem: FetchPlacesRequest(
                latitude: coordinates.latitude,
                longitude: coordinates.longitude,
                radius: radius
            )
        )
    }
    
    private func requestLocationServices() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func fetchRecommendedVenues(requestItem: FetchPlacesRequest) {
        showLoaderReplaySubject.onNext(true)
        fetchVenues
            .display(request: requestItem)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (venues) in
                self?.showEmptyViewReplaySubject.onNext(venues.isEmpty)
                self?.showLoaderReplaySubject.onNext(false)
                self?.venues = venues
                self?.venueCellItems = venues.map({ venue in
                    VenueCellItem(
                        name: venue.name,
                        id: venue.id,
                        category: venue.categories.first?.name,
                        distance: venue.distance.formattedDistance,
                        location: venue.location.formattedAddress,
                        photo: nil
                    )
                })
                self?.startUpPhotoFetching()
                self?.updateDataSource(animated: true)
            }, onError: { [weak self] error in
                self?.showEmptyViewReplaySubject.onNext(true)
                self?.showLoaderReplaySubject.onNext(false)
                self?.showErrorReplaySubject.onNext(error)
            })
            .disposed(by: disposeBag)
    }
    
    private func startUpPhotoFetching() {
        let ids = venues.map({ $0.id })
        generateIndexMap(for: ids)
        for id in ids {
            fetchPhotos
                .fetch(for: id)
                .observe(on: MainScheduler.instance)
                .compactMap({ $0.first })
                .subscribe(onNext: { [weak self] photo in
                    guard let index = self?.indexMap[id] else { return }
                    self?.venueCellItems[index].photo = photo.url
                    self?.updateDataSource(animated: false)
                })
                .disposed(by: disposeBag)
        }
    }
    
    private func generateIndexMap(for ids: [String]) {
        for (index, id) in ids.enumerated() {
            indexMap[id] = index
        }
    }
    
    private func emitRadiuses() {
        radiusDataSourceReplaySubject.onNext(radiuses.map({$0.formattedDistance}))
    }
}

extension VenueListViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        radiusSelected(at: 0)
    }
}
