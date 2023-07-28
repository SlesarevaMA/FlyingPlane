//
//  RecordsViewController.swift
//  FlyingPlane
//
//  Created by Margarita Slesareva on 10.07.2023.
//

import UIKit

final class RecordsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let tableView = UITableView()
    private let repository: RecordsRepository
    
    init(repository: RecordsRepository) {
        self.repository = repository
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.frame = view.bounds
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RecordTableViewCell.self, forCellReuseIdentifier: RecordTableViewCell.reuseIdentifier)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repository.getRecords().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: RecordTableViewCell.reuseIdentifier, for: indexPath
        ) as? RecordTableViewCell else {
            return UITableViewCell()
        }
        
        let records = repository.getRecords()
        cell.configure(with: records[indexPath.row])
        
        return cell
    }
}
