//
//  RecordsViewController.swift
//  FlyingPlane
//
//  Created by Margarita Slesareva on 10.07.2023.
//

import UIKit

final class RecordsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let tableView = UITableView()
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
        
        view.addSubview(tableView)
        tableView.frame = view.bounds
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RecordTableViewCell.self, forCellReuseIdentifier: RecordTableViewCell.reuseIdentifier)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.getRecords().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecordTableViewCell.reuseIdentifier, for: indexPath) as? RecordTableViewCell else {
            return UITableViewCell()
        }
        
        let recordString = "\(dataSource.getRecords()[indexPath.row])"
        
        cell.configure(text: recordString)
        
        return cell
    }
}
