//
//  VenueTableViewCell.swift
//  VenueExplorer
//
//  Created by Yuri Gurgenidze on 12/07/2022.
//

import UIKit
import RxSwift
import SDWebImage

class VenueTableViewCell: UITableViewCell {
    
    private var activityIndicator: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .medium)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.startAnimating()
        return activityIndicatorView
    }()
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        label.font = .preferredFont(forTextStyle: .headline)
        label.numberOfLines = 0
        return label
    }()
    
    private var categoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.isHidden = true
        label.numberOfLines = 0
        return label
    }()
    
    private var distanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.isHidden = true
        label.numberOfLines = 0
        return label
    }()
    
    private var locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()
    
    private var placeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    private func commonInit() {
        self.selectionStyle = .none
        setupViews()
    }
    
    func configure(with model: VenueCellItem) {
        self.nameLabel.text = model.id
        distanceLabel.setAndShowIfPossible(text: model.distance)
        categoryLabel.setAndShowIfPossible(text: model.category)
        locationLabel.setAndShowIfPossible(text: model.location)
        distanceLabel.setAndShowIfPossible(text: model.distance)
        nameLabel.setAndShowIfPossible(text: model.name)
        placeImageView.sd_setImage(with: model.photo)
        toggleAnimation(isAnimated: model.photo == nil)
    }
    
    private func setupViews() {
        addSubview(placeImageView)
        
        placeImageView.widthAnchor.constraint(equalToConstant: Constants.placeImageViewWidth).isActive = true
        placeImageView.heightAnchor.constraint(equalToConstant: Constants.placeImageViewHeight).isActive = true
        placeImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.placeImageViewLeading).isActive = true
        placeImageView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.placeImageViewTop).isActive = true
        placeImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Constants.placeImageViewBottom).isActive = true
        
        placeImageView.addSubview(activityIndicator)
        
        activityIndicator.topAnchor.constraint(equalTo: placeImageView.topAnchor).isActive = true
        activityIndicator.bottomAnchor.constraint(equalTo: placeImageView.bottomAnchor).isActive = true
        activityIndicator.leadingAnchor.constraint(equalTo: placeImageView.leadingAnchor).isActive = true
        activityIndicator.trailingAnchor.constraint(equalTo: placeImageView.trailingAnchor).isActive = true
        
        
        let stackView = UIStackView()
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(categoryLabel)
        stackView.addArrangedSubview(distanceLabel)
        stackView.addArrangedSubview(locationLabel)
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.alignment = .leading
        
        stackView.leadingAnchor.constraint(equalTo: placeImageView.trailingAnchor, constant: Constants.stackViewLeading).isActive = true
        stackView.topAnchor.constraint(equalTo: placeImageView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Constants.stackViewBottom).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Constants.stackViewTrailing).isActive = true
        layoutIfNeeded()
        
    }
    
    private func toggleAnimation(isAnimated: Bool) {
        isAnimated ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
}

extension VenueTableViewCell {
    enum Constants {
        static let placeImageViewWidth: CGFloat = 100
        static let placeImageViewHeight: CGFloat = 100
        static let placeImageViewLeading: CGFloat = 16
        static let placeImageViewTop: CGFloat = 16
        static let placeImageViewBottom: CGFloat = -16
        
        static let stackViewLeading: CGFloat = 16
        static let stackViewBottom: CGFloat = -8
        static let stackViewTrailing: CGFloat = -8
    }
}
