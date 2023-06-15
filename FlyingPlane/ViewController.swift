//
//  ViewController.swift
//  FlyingPlane
//
//  Created by Margarita Slesareva on 15.06.2023.
//

import UIKit

private enum Metrics {
    static let rockProportion = 0.2
}

final class ViewController: UIViewController {
    
    private let leftRockImageView = UIImageView()
    private let rightRockImageView = UIImageView()
    private let skyView = SkyView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    private func configure() {
        addViews()
        addConstraints()
        configureSubviews()
    }
    
    private func addViews() {
        [leftRockImageView, rightRockImageView, skyView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            leftRockImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            leftRockImageView.topAnchor.constraint(equalTo: view.topAnchor),
            leftRockImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            leftRockImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Metrics.rockProportion),
            
            skyView.leadingAnchor.constraint(equalTo: leftRockImageView.trailingAnchor),
            skyView.topAnchor.constraint(equalTo: view.topAnchor),
            skyView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            rightRockImageView.leadingAnchor.constraint(equalTo: skyView.trailingAnchor),
            rightRockImageView.topAnchor.constraint(equalTo: view.topAnchor),
            rightRockImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            rightRockImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            rightRockImageView.widthAnchor.constraint(equalTo: leftRockImageView.widthAnchor)
        ])
    }
    
    private func configureSubviews() {
        leftRockImageView.image = UIImage(systemName: "chevron.right.to.line")
        leftRockImageView.backgroundColor = .gray
        leftRockImageView.tintColor = .black
        
        rightRockImageView.image = UIImage(systemName: "chevron.left.to.line")
        rightRockImageView.backgroundColor = .gray
        rightRockImageView.tintColor = .black
        skyView.backgroundColor = .systemCyan
        
        
        UIView.animate(withDuration: 3, delay: 0.0, options: [.repeat]) {
            self.rightRockImageView.frame.origin = .init(x: 0, y: self.view.frame.height)
        }
        
        UIView.animate(withDuration: 3, delay: 0.0, options: [.repeat]) {
            self.leftRockImageView.frame.origin = .init(x: 0, y: self.view.frame.height)
        }
    }
}
