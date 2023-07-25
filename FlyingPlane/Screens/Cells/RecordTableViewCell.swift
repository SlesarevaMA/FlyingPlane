//
//  RecordTableViewCell.swift
//  FlyingPlane
//
//  Created by Margarita Slesareva on 10.07.2023.
//

import UIKit

final class RecordTableViewCell: UITableViewCell, Identifiable {
    
    private let titleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(titleLabel)
        titleLabel.frame = bounds
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }    
    
    func configure(text: String) {
        titleLabel.text = text
    }
    
    private func configure() {
        titleLabel.textAlignment = .center
    }
}
