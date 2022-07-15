//
//  RadiusPickerView.swift
//  VenueExplorer
//
//  Created by Yuri Gurgenidze on 14/07/2022.
//

import UIKit

protocol RadiusPickerViewDelegate: AnyObject {
    func radiusPickerViewDidTap(_ pickerView: RadiusPickerView)
}

class RadiusPickerView: UIView {
    var containerView: UIView = {
        let view = UIView()
        view.layer.borderColor = Constants.containerViewBorderColor
        view.layer.borderWidth = Constants.containerViewBorderWidth
        view.layer.cornerRadius = Constants.containerViewBorderRadius
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var radiusLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.radiusText
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var dropDownImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Constants.dropDownImage
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var valueLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    weak var delegate: RadiusPickerViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(containerView)
        containerView.addSubview(radiusLabel)
        containerView.addSubview(valueLabel)
        containerView.addSubview(dropDownImage)
        containerView.backgroundColor = .systemBackground
        containerView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.containerViewTop).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Constants.containerViewBottom).isActive = true
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.containerViewLeading).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Constants.containerViewTrailing).isActive = true
        
        radiusLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Constants.radiusTop).isActive = true
        radiusLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.radiusLeading).isActive = true
        valueLabel.topAnchor.constraint(equalTo: radiusLabel.bottomAnchor, constant: Constants.valueTop).isActive = true
        valueLabel.leadingAnchor.constraint(equalTo: radiusLabel.leadingAnchor).isActive = true
        
        dropDownImage.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: Constants.dropDownImageTrailing).isActive = true
        dropDownImage.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        dropDownImage.heightAnchor.constraint(equalToConstant: Constants.dropDownImageHeight).isActive = true
        dropDownImage.widthAnchor.constraint(equalToConstant: Constants.dropDownImageWidth).isActive = true
        
        containerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pickerTapped)))
    }
    
    @objc func pickerTapped() {
        delegate?.radiusPickerViewDidTap(self)
    }
    
}

extension RadiusPickerView {
    enum Constants {
        static let containerViewTop: CGFloat = 8
        static let containerViewBottom: CGFloat = -8
        static let containerViewLeading: CGFloat = 8
        static let containerViewTrailing: CGFloat = -8
        static let containerViewBorderWidth: CGFloat = 1
        static let containerViewBorderColor = UIColor.gray.cgColor
        static let containerViewBorderRadius: CGFloat = 5
        
        static let radiusTop: CGFloat = 6
        static let radiusLeading: CGFloat = 8
        static let radiusText = "Radius"

        static let valueTop: CGFloat = 4
        
        static let dropDownImageTrailing: CGFloat = -6
        static let dropDownImageWidth: CGFloat = 20
        static let dropDownImageHeight: CGFloat = 20
        static let dropDownImage = UIImage(systemName: "chevron.down")
    }
}
