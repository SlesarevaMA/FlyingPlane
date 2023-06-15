//
//  SkyView.swift
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
    static let buttonHeight: CGFloat = 30
    static let step: CGFloat = 10
}

final class SkyView: UIView {
    private let planeImageView = UIImageView()
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
        [planeImageView, leftButton, rightButton].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            planeImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            planeImageView.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -(Metrics.verticalSpacing + Metrics.buttonHeight)
            ),
            planeImageView.heightAnchor.constraint(equalTo: planeImageView.widthAnchor),
            planeImageView.heightAnchor.constraint(equalToConstant: Metrics.planeHeight),
            
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
        planeImageView.image = UIImage(systemName: "arrow.up")
        planeImageView.backgroundColor = .clear
        planeImageView.tintColor = .systemYellow
        
        leftButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        leftButton.backgroundColor = .clear
        leftButton.tintColor = .black
        leftButton.addTarget(self, action: #selector(`left`), for: .touchUpInside)
        
        rightButton.setImage(UIImage(systemName: "arrow.right"), for: .normal)
        rightButton.backgroundColor = .clear
        rightButton.tintColor = .black
        rightButton.addTarget(self, action: #selector(`right`), for: .touchUpInside)
    }
    
    @objc private func right() {
        let nextFrame = planeImageView.frame.offsetBy(dx: Metrics.step, dy: 0)
        
        if buttonsIntersects(with: nextFrame) {
            return
        }
                
        if nextFrame.maxX > frame.width {
            return
        }
        
        animatedStep(nextFrame: nextFrame)
    }
    
    @objc private func left() {
        let nextFrame = planeImageView.frame.offsetBy(dx: -Metrics.step, dy: 0)
        
        if buttonsIntersects(with: nextFrame) {
            return
        }
        
        if nextFrame.minX < 0 {
            return
        }
        
       animatedStep(nextFrame: nextFrame)
    }
    
    private func buttonsIntersects(with frame: CGRect) -> Bool {
        for button in [leftButton, rightButton] {
            if frame.intersects(button.frame) {
                return true
            }
        }
        
        return false
    }
    
    private func animatedStep(nextFrame: CGRect) {
        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseInOut]) {
            self.planeImageView.frame = nextFrame
        }
    }
}
