//
//  JPauseButtonView.swift
//  J'Ma Radio
//
//  Created by Федор Рубченков on 15.02.2023.
//

import UIKit

final class JPauseButtonView: UIControl {
    
    private let viewsInset: CGFloat = 22.0
    private let containerHeight: CGFloat = 45
    private let containerWidth: CGFloat = 45
    private let viewsOffset: CGFloat = 30
    private lazy var gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor(red: 0.259, green: 0.259, blue: 0.259, alpha: 1).cgColor,
                           UIColor(red: 0.706, green: 0.596, blue: 0.412, alpha: 1).cgColor]
        gradient.masksToBounds = true
        gradient.startPoint = CGPoint(x: 0.25, y: 0.5)
        gradient.endPoint = CGPoint(x: 0.75, y: 0.5)
        return gradient
    }()
    private lazy var blackGradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor(red: 0.016, green: 0.004, blue: 0.078, alpha: 1).cgColor,
                           UIColor(red: 0.11, green: 0.11, blue: 0.11, alpha: 1).cgColor]
        gradient.startPoint = CGPoint(x: 0.25, y: 0.5)
        gradient.endPoint = CGPoint(x: 0.75, y: 0.5)
        gradient.masksToBounds = true
        return gradient
    }()
    
    override var isHighlighted: Bool {
        didSet {
            blackGradientLayer.colors = isHighlighted ? [UIColor(red: 0.11, green: 0.11, blue: 0.11, alpha: 1).cgColor, UIColor(red: 0.016, green: 0.004, blue: 0.078, alpha: 1).cgColor] : [UIColor(red: 0.016, green: 0.004, blue: 0.078, alpha: 1).cgColor, UIColor(red: 0.11, green: 0.11, blue: 0.11, alpha: 1).cgColor]
            gradientLayer.colors = isHighlighted ? [UIColor(red: 0.706, green: 0.596, blue: 0.412, alpha: 1).cgColor, UIColor(red: 0.259, green: 0.259, blue: 0.259, alpha: 1).cgColor] : [UIColor(red: 0.259, green: 0.259, blue: 0.259, alpha: 1).cgColor, UIColor(red: 0.706, green: 0.596, blue: 0.412, alpha: 1).cgColor]
        }
    }

    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var buttonContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    private lazy var leftView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.layer.cornerRadius = 6
        view.backgroundColor = .j_white()
        return view
    }()
    
    private lazy var rightView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.layer.cornerRadius = 6
        view.backgroundColor = .j_white()
        return view
    }()
    
    private lazy var playImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "triangle"))
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        j_setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureShadow(lightAppearance: traitCollection.userInterfaceStyle == .light)
        j_layout()
    }
    
    override func sizeToFit() {
        j_layout()
        bounds = CGRect(x: 0, y: 0, width: containerWidth + 2*viewsOffset + 10, height: containerHeight + 2*viewsOffset + 10)
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if self.traitCollection != previousTraitCollection {
            configureShadow(lightAppearance: traitCollection.userInterfaceStyle == .light)
            configureBackground(lightAppearance: traitCollection.userInterfaceStyle == .light)
        }
    }
    
    func show(_ isPlaying: Bool) {
        if isPlaying {
            leftView.isHidden = false
            rightView.isHidden = false
            playImage.isHidden = true
        } else {
            playImage.isHidden = false
            leftView.isHidden = true
            rightView.isHidden = true
        }
    }
}

private extension JPauseButtonView {
    
    func configureBackground(lightAppearance: Bool) {
        if lightAppearance {
            buttonContainerView.layer.insertSublayer(gradientLayer, at: 0)
            gradientLayer.frame = buttonContainerView.bounds
            buttonContainerView.backgroundColor = UIColor(red: 0.706, green: 0.596, blue: 0.412, alpha: 1)
            backgroundColor = .clear
        } else {
            gradientLayer.removeFromSuperlayer()
            buttonContainerView.layer.insertSublayer(blackGradientLayer, at: 0)
            blackGradientLayer.frame = buttonContainerView.bounds
            backgroundColor = .clear
        }
    }
    
    func configureShadow(lightAppearance: Bool) {
        if lightAppearance {
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOpacity = 0.3
            layer.shadowRadius = 7
            layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
            let cgPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.allCorners], cornerRadii: CGSize(width: 52.5, height: 52.5)).cgPath
            layer.shadowPath = cgPath
            
        } else {
            layer.shadowColor = UIColor.white.cgColor
            layer.shadowOpacity = 0.2
            layer.shadowRadius = 7
            layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
            let cgPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.allCorners], cornerRadii: CGSize(width: 52.5, height: 52.5)).cgPath
            layer.shadowPath = cgPath
        }
    }
    
    func j_setup() {
        addSubview(buttonContainerView)
        playImage.isHidden = false
        layer.masksToBounds = false
        buttonContainerView.layer.masksToBounds = true
        containerView.addSubview(playImage)
        containerView.addSubview(leftView)
        containerView.addSubview(rightView)
        buttonContainerView.addSubview(containerView)
        buttonContainerView.layer.cornerRadius = 52.5// (viewsOffset * 2.0 + containerWidth)/2.0
        configureBackground(lightAppearance: traitCollection.userInterfaceStyle == .light)
        containerView.isUserInteractionEnabled = false
        buttonContainerView.isUserInteractionEnabled = false
    }
    
    func j_layout() {
        containerView.frame = CGRect(x: viewsOffset, y: viewsOffset, width: containerWidth, height: containerHeight)
        buttonContainerView.frame = CGRect(x: 5, y: 5, width: containerWidth + 2*viewsOffset, height: containerHeight + 2*viewsOffset)
        leftView.frame = CGRect(x: 0, y: 0, width: 12, height: containerHeight)
        rightView.frame = CGRect(x: containerView.frame.width - 12, y: 0, width: 12, height: containerHeight)
        playImage.frame = CGRect(x: (containerWidth - 33)/2.0, y: (containerHeight - 43)/2.0, width: 37, height: 43)
        configureBackground(lightAppearance: traitCollection.userInterfaceStyle == .light)
    }
    
}
