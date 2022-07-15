//
//  VenueListViewController.swift
//  VenueExplorer
//
//  Created by Yuri Gurgenidze on 12/07/2022.
//

import UIKit
import RxSwift
import RxCocoa
import CoreLocation

class VenueListViewController: UIViewController {
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            VenueTableViewCell.self,
            forCellReuseIdentifier: String(describing: VenueTableViewCell.self)
        )
        tableView.rowHeight = UITableView.automaticDimension
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.bounces = false
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    private var activityIndicator: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .large)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicatorView
    }()
    
    private var emptyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = Constants.emptyImage
        imageView.isHidden = true
        return imageView
    }()
    
    var pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    var radiusPickerView: RadiusPickerView = {
        let view = RadiusPickerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemUltraThinMaterial)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.backgroundColor = .clear
        return blurEffectView
    }()
    
    let pickerViewHelperTF = UITextField(frame: .zero)
    
    var locationManager: CLLocationManager?
    
    private let disposeBag = DisposeBag()
    var viewModel: VenueListViewModelType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindModels()
    }
    
    private func setupViews() {
        title = Constants.title
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        view.addSubview(emptyImageView)
        view.addSubview(blurEffectView)
        view.addSubview(radiusPickerView)
        view.addSubview(pickerViewHelperTF)
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.prefersLargeTitles = true
        
        pickerViewHelperTF.inputView = pickerView
        radiusPickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        radiusPickerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Constants.radiusPickerWidthMultiplier).isActive = true
        radiusPickerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        radiusPickerView.heightAnchor.constraint(equalToConstant: Constants.radiusPickerHeight).isActive = true
        activityIndicator.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        activityIndicator.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        activityIndicator.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        activityIndicator.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        emptyImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        emptyImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emptyImageView.widthAnchor.constraint(equalToConstant: Constants.emptyImageWidth).isActive = true
        emptyImageView.heightAnchor.constraint(equalToConstant: Constants.emptyImageHeight).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        blurEffectView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        blurEffectView.bottomAnchor.constraint(equalTo: radiusPickerView.bottomAnchor).isActive = true
        blurEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        blurEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.contentInset = Constants.tableViewInsets
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(resignResponder)))
        radiusPickerView.delegate = self
        viewModel.configureTableView.onNext(tableView)
    }
    
    private func bindModels() {
        viewModel
            .showError
            .bind(to: rx.showError)
            .disposed(by: disposeBag)
        
        viewModel
            .showLoader
            .subscribe(onNext: showLoader(isActive:))
            .disposed(by: disposeBag)
        
        viewModel
            .showEmptyView
            .subscribe(onNext: showEmptyView(isActive:))
            .disposed(by: disposeBag)
        
        viewModel
            .radiusDataSource
            .bind(to: pickerView.rx.itemTitles) { (_, element) in
                return element
            }.disposed(by: disposeBag)
        
        pickerView.rx
            .itemSelected
            .map({$0.row})
            .bind(to: viewModel.radiusSelected)
            .disposed(by: disposeBag)
        
        viewModel
            .showRadius
            .observe(on: MainScheduler.instance)
            .map({$0.formattedDistance})
            .bind(to: radiusPickerView.valueLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    @objc func resignResponder() {
        pickerViewHelperTF.resignFirstResponder()
    }
    
    private func showLoader(isActive: Bool) {
        isActive ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
    
    private func showEmptyView(isActive: Bool) {
        emptyImageView.isHidden = !isActive
    }
}

extension VenueListViewController: RadiusPickerViewDelegate {
    func radiusPickerViewDidTap(_ pickerView: RadiusPickerView) {
        pickerViewHelperTF.becomeFirstResponder()
    }
}

extension VenueListViewController {
    enum Constants {
        static let title = "Venues"
        static let tableViewInsets = UIEdgeInsets(top: 70, left: 0, bottom: 0, right: 0)
        static let emptyImage = UIImage(named: "empty_icon")
        
        static let radiusPickerWidthMultiplier: CGFloat = 0.4
        static let radiusPickerHeight: CGFloat = 70
        static let emptyImageHeight: CGFloat = 100
        static let emptyImageWidth: CGFloat = 100
    }
}
