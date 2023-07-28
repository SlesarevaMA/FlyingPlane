//
//  RecordTableViewCell.swift
//  FlyingPlane
//
//  Created by Margarita Slesareva on 10.07.2023.
//

import UIKit
import SnapKit

private enum Metrics {
    static let spacing: CGFloat = 20
    
    static let font: UIFont = .systemFont(ofSize: 25, weight: .semibold)
}

final class RecordTableViewCell: UITableViewCell, Identifiable {
    private let numberLabel = UILabel()
    private let nameLabel = UILabel()
    private let scoreLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews()
        addConstraints()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }    
    
    func configure(with model: RecordModel) {
        numberLabel.text = "\(model.number)"
        nameLabel.text = model.name
        scoreLabel.text = "\(model.score)"
    }
    
    private func addSubviews() {
        [numberLabel, nameLabel, scoreLabel].forEach {
            addSubview($0)
        }
    }
    
    private func addConstraints() {
        numberLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Metrics.spacing)
            $0.leading.equalToSuperview().offset(Metrics.spacing)
            $0.bottom.equalToSuperview().inset(Metrics.spacing)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Metrics.spacing)
            $0.leading.equalTo(numberLabel.snp.trailing).offset(Metrics.spacing)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(Metrics.spacing)
        }
        
        scoreLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Metrics.spacing)
            $0.leading.equalTo(nameLabel.snp.trailing).offset(Metrics.spacing)
            $0.bottom.equalToSuperview().inset(Metrics.spacing)
            $0.trailing.equalToSuperview().inset(Metrics.spacing)
        }
    }
    
    private func configure() {
        numberLabel.font = Metrics.font
        numberLabel.textAlignment = .center
        
        nameLabel.textAlignment = .center
        nameLabel.font = Metrics.font
        
        scoreLabel.font = Metrics.font
    }
}
