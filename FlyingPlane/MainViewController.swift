//
//  MainViewController.swift
//  FlyingPlane
//
//  Created by Margarita Slesareva on 04.07.2023.
//

import UIKit
import SnapKit

private enum Metrics {
    static let horizontalSpacing: CGFloat = 10
    static let verticalSpacing: CGFloat = 12
}

final class MainViewController: UIViewController {
    private let startButton = UIButton()
    private let settingsButton = UIButton()
    private let recordsButton = UIButton()
    
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
        [startButton, settingsButton, recordsButton].forEach {
            view.addSubview($0)
        }
    }
    
    private func addConstraints() {
        startButton.snp.makeConstraints {
            $0.centerX.equalTo(view.snp.centerX)
            $0.leading.greaterThanOrEqualToSuperview().offset(Metrics.horizontalSpacing)
        }
        
        settingsButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.top.equalTo(startButton.snp.bottom).offset(Metrics.verticalSpacing)
            $0.leading.greaterThanOrEqualToSuperview().offset(Metrics.horizontalSpacing)
        }
        
        recordsButton.snp.makeConstraints {
            $0.top.equalTo(settingsButton.snp.bottom).offset(Metrics.verticalSpacing)
            $0.centerX.equalToSuperview()
            $0.leading.greaterThanOrEqualToSuperview().offset(Metrics.horizontalSpacing)
        }
    }
    
    private func configureViews() {
        startButton.setTitle("Start", for: .normal)
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        
        settingsButton.setTitle("Settings", for: .normal)
        settingsButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)

        recordsButton.setTitle("Records", for: .normal)
        recordsButton.addTarget(self, action: #selector(recordsButtonTapped), for: .touchUpInside)
    }
    
    @objc private func startButtonTapped() {
        let animationLogic = AnimationLogic()
        let gameViewController = GameViewController(animationLogic: animationLogic)
        animationLogic.view = gameViewController
        animationLogic.dataSource = dataSource
        
        navigationController?.pushViewController(gameViewController, animated: true)
    }
    
    @objc private func settingsButtonTapped() {
        let settingsViewController = SettingsViewController(dataSource: dataSource)
        navigationController?.pushViewController(settingsViewController, animated: true)
    }

    @objc private func recordsButtonTapped() {
        let recordsViewController = RecordsViewController(dataSource: dataSource)
        navigationController?.pushViewController(recordsViewController, animated: true)
    }
}
