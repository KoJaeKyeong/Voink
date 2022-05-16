//
//  RecordListView.swift
//  Voink
//
//  Created by Jae Kyeong Ko on 2022/05/16.
//

import UIKit
import AVFoundation

final class RecordListView: UITableView {
    
    let viewModel = RecordListViewModel()
    let player = AVAudioPlayer()
    
    override func layoutSubviews() {
        configure()
    }
    
    private func configure() {
        dataSource = self
        delegate = self
        register(RecordListCell.self, forCellReuseIdentifier: RecordListCell().identifier)
        register(RecordListHeaderCell.self, forHeaderFooterViewReuseIdentifier: RecordListHeaderCell().identifier)
    }
}

extension RecordListView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return viewModel.heightForHeaderInSection
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: RecordListHeaderCell().identifier) as? RecordListHeaderCell else { return nil }

        headerView.titleLabel.text = viewModel.title(section: section)
        headerView.countOfRecordLabel.text = viewModel.countOfRecord(section: section)
        headerView.contentLabel.text = viewModel.content(section: section)

        return headerView
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.heightForRowAt
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecordListCell().identifier, for: indexPath) as? RecordListCell else { return UITableViewCell() }

        cell.delegate = self
        cell.totalTimeLabel.text = viewModel.totalTime(section: indexPath.section, row: indexPath.row)

        return cell
    }
}
