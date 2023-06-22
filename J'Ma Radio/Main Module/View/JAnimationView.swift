//
//  JAnimationView.swift
//  J'Ma Radio
//
//  Created by Алексей Волобуев on 27.03.2023.
//

import UIKit

class JAnimationView: UIView {

    private let imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 240, height: 128))
        
        return imageView
    }()
    
    private var firstLabel: UILabel = {
        var label = UILabel(frame: CGRect(x: 0, y: 0, width: 159, height: 25))
        label.text = "sat"
        label.textAlignment = .center
        label.font = UIFont.mainLightFont(size: 28)
        label.textColor = UIColor.j_accent()
        return label
    }()
    
    private var secondLabel: UILabel = {
        var secondlabel = UILabel(frame: CGRect(x: 0, y: 0, width: 159, height: 25))
        secondlabel.text = "nam"
        secondlabel.alpha = 0
        secondlabel.textAlignment = .center
        secondlabel.font = UIFont.mainLightFont(size: 28)
        secondlabel.textColor = UIColor.j_accent()
        return secondlabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(firstLabel)
        addSubview(imageView)
        addSubview(secondLabel)
        backgroundColor = UIColor.j_backgroundColor()
        setupConstraints()
        traitCollectionDidChange(traitCollection)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if self.traitCollection.userInterfaceStyle == UIUserInterfaceStyle.light {
            self.imageView.image = UIImage(named: "logo_main_black")
        } else {
            self.imageView.image = UIImage(named: "logo_main_white")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        let safeArea = safeAreaLayoutGuide
        imageView.translatesAutoresizingMaskIntoConstraints = false
        firstLabel.translatesAutoresizingMaskIntoConstraints = false
        secondLabel.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 150).isActive = true
        firstLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
        firstLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -166).isActive = true
        secondLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
        secondLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -166).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
   
    func startAnimation(with completion: @escaping (()->())) {
        UIView.animate(withDuration: 1.5, animations: {
            self.firstLabel.alpha = 0
        }) { done in
            if done {
                UIView.animate(withDuration: 1.5, animations: {
                    self.secondLabel.alpha = 1
                }) { done in
                    if done {
                        completion()
                    }
                }
            }
        }
    }

}
