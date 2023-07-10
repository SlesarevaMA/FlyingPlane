//
//  SettingsViewController.swift
//  FlyingPlane
//
//  Created by Margarita Slesareva on 04.07.2023.
//

import UIKit
import SnapKit

private enum Metrics {
    static let verticalSpacing: CGFloat = 20
    static let horizontalSpacing: CGFloat = 12
}

final class SettingsViewController: UIViewController {
    private let planeItems = ["Plane-1", "Plane-2", "Plane-3"]
    private let speedItems = ["Slow", "Average", "High"]
    
    private let personImageView = UIImageView()
    private let planeLabel = UILabel()
    private let speedLabel = UILabel()
    private let nameLabel = UILabel()
    private let planeSegmentControl = UISegmentedControl()
    private let speedSegmentControl = UISegmentedControl()
    private let nameTextView = UITextView()
    
    private let dataSource: DataSource
    
    init(dataSource: DataSource) {
        self.dataSource = dataSource
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        addViews()
        addConstraints()
        configureViews()
    }
    
    private func addViews() {
        [personImageView, planeLabel, planeSegmentControl, speedLabel,
         speedSegmentControl, nameLabel, nameTextView
        ].forEach {
            view.addSubview($0)
        }
    }
    
    private func addConstraints() {
        personImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(Metrics.horizontalSpacing)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(Metrics.verticalSpacing)
            $0.trailing.equalToSuperview().inset(Metrics.verticalSpacing)
        }
        
        nameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(Metrics.horizontalSpacing)
            $0.top.equalTo(personImageView.snp.bottom).offset(Metrics.verticalSpacing)
        }
        
        nameTextView.snp.makeConstraints {
            $0.leading.equalTo(nameLabel.snp.trailing).offset(Metrics.horizontalSpacing)
            $0.top.equalTo(personImageView.snp.bottom).offset(Metrics.verticalSpacing)
            $0.trailing.equalToSuperview().inset(Metrics.horizontalSpacing)
            $0.bottom.equalTo(nameLabel.snp.bottom)
            $0.height.equalTo(nameLabel.snp.height)
        }
        
        planeLabel.snp.makeConstraints {
            $0.leading.equalTo(nameLabel.snp.leading)
            $0.top.equalTo(nameLabel.snp.bottom).offset(Metrics.verticalSpacing)
        }
        
        planeSegmentControl.snp.makeConstraints {
            $0.leading.equalTo(planeLabel.snp.trailing).offset(Metrics.horizontalSpacing)
            $0.top.equalTo(planeLabel.snp.top)
            $0.trailing.equalToSuperview().inset(Metrics.horizontalSpacing)
        }
        
        speedLabel.snp.makeConstraints {
            $0.leading.equalTo(planeLabel.snp.leading)
            $0.top.equalTo(planeLabel.snp.bottom).offset(Metrics.verticalSpacing)
        }
        
        speedSegmentControl.snp.makeConstraints {
            $0.leading.equalTo(speedLabel.snp.trailing).offset(Metrics.horizontalSpacing)
            $0.top.equalTo(speedLabel.snp.top)
            $0.trailing.equalToSuperview().inset(Metrics.horizontalSpacing)
        }
    }
    
    private func configureViews() {
        view.backgroundColor = .white
        
        personImageView.image = UIImage(named: "Stone")
        
        planeLabel.text = "Plane"
        speedLabel.text = "Speed"
        nameLabel.text = "Name"
        
        nameTextView.text = "John"
        nameTextView.backgroundColor = .systemGray2
        nameTextView.textAlignment = .center
                
        for (index, item) in planeItems.enumerated() {
            planeSegmentControl.insertSegment(withTitle: item, at: index, animated: false)
        }
        planeSegmentControl.addTarget(self, action: #selector(planeChanged(sender:)), for: .valueChanged)
        
        for (index, item) in speedItems.enumerated() {
            speedSegmentControl.insertSegment(withTitle: item, at: index, animated: false)
        }
        speedSegmentControl.addTarget(self, action: #selector(speedChanged(sender:)), for: .valueChanged)
    }
    
    @objc private func planeChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            dataSource.setPlane(.plane1)
        case 1:
            dataSource.setPlane(.plane2)
        case 2:
            dataSource.setPlane(.plane3)
        default:
            break
        }
    }
    
    @objc private func speedChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            dataSource.setSpeed(.slow)
        case 1:
            dataSource.setSpeed(.average)
        case 2:
            dataSource.setSpeed(.high)
        default:
            break
        }
    }
}
