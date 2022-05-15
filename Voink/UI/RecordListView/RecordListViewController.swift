//
//  RecordListViewController.swift
//  Voink
//
//  Created by Jae Kyeong Ko on 2022/05/03.
//

import UIKit

final class RecordListViewController: UITableViewController {
    
    let viewModel = RecordListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = 
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section: section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecordListCell().reuseIdentifier, for: indexPath) as? RecordListCell else { return UITableViewCell() }
        
        
        return cell
    }
}
