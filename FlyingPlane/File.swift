//
//  File.swift
//  FlyingPlane
//
//  Created by Margarita Slesareva on 15.06.2023.
//

import UIKit

private enum Metrics {
    static let verticalSpacing: CGFloat = 20
    static let minimumVerticalSpacing: CGFloat = 8
    static let horizontalSpacing: CGFloat = 8
    static let planeHeight: CGFloat = 80
    static let buttonHeight: CGFloat = 50
}

final class SkyView: UIView {
    private let planeView = UIImageView()
    private let leftButton = UIButton()
    private let rightButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure() {
        addSubviews()
        addConstraints()
        configureViews()
    }
    
    private func addSubviews() {
        [planeView, leftButton, rightButton].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            planeView.centerXAnchor.constraint(equalTo: centerXAnchor),
            planeView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Metrics.verticalSpacing),
            planeView.heightAnchor.constraint(equalTo: planeView.widthAnchor),
            planeView.heightAnchor.constraint(equalToConstant: Metrics.planeHeight),
            
            leftButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metrics.horizontalSpacing),
            leftButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Metrics.verticalSpacing),
            leftButton.heightAnchor.constraint(equalTo: leftButton.widthAnchor),
            leftButton.heightAnchor.constraint(equalToConstant: Metrics.buttonHeight),
            
            rightButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Metrics.horizontalSpacing),
            rightButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Metrics.verticalSpacing),
            rightButton.heightAnchor.constraint(equalTo: rightButton.widthAnchor),
            rightButton.heightAnchor.constraint(equalToConstant: Metrics.buttonHeight),
        ])
    }
    
    private func configureViews() {
        planeView.image = UIImage(systemName: "arrow.up")
        planeView.backgroundColor = .clear
        planeView.tintColor = .systemGray
        
        leftButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        leftButton.backgroundColor = .clear
        leftButton.tintColor = .black
        
        rightButton.setImage(UIImage(systemName: "arrow.right"), for: .normal)
        rightButton.backgroundColor = .clear
        rightButton.tintColor = .black
    }
}
