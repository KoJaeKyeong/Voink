//
//  RecordListViewController.swift
//  Voink
//
//  Created by Jae Kyeong Ko on 2022/05/03.
//

import UIKit
import AVFoundation
import GoogleMaps
import CoreLocation
import SnapKit

final class RecordListViewController: UIViewController {
    
    let viewModel = RecordListViewModel()
    let player = SimplePlayer.shared
    let recordListView = UITableView(frame: .zero, style: .grouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let coordinate = CLLocationManager().location?.coordinate else { return }
        viewModel.reverseGeocode(coordinate: coordinate, navigationItem: navigationItem, view: view)
        
        view.addSubview(recordListView)
        
        [recordListView].forEach { view.addSubview($0) }
        
        recordListView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configure() {
        configureAttribute()
        configureLayout()
    }
    
    private func configureAttribute() {
        recordListView.dataSource = self
        recordListView.delegate = self
        recordListView.register(RecordListCell.self, forCellReuseIdentifier: RecordListCell().identifier)
        recordListView.register(RecordListHeaderCell.self, forHeaderFooterViewReuseIdentifier: RecordListHeaderCell().identifier)
    }
    
    private func configureLayout() {
        [recordListView].forEach { view.addSubview($0) }

        recordListView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension RecordListViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        viewModel.reverseGeocode(coordinate: location.coordinate, navigationItem: navigationItem, view: view)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error in record listView: \(error.localizedDescription)")
    }
}

extension RecordListViewController: UITableViewDataSource, UITableViewDelegate {
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
        player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 10), queue: DispatchQueue.main) { time in
            cell.currentTimeLabel.text = self.viewModel.secondToString(sec: self.player.currentTime)
        }
        cell.currentContentsURL = viewModel.itemURL(section: indexPath.section, row: indexPath.row)
        cell.totalTimeLabel.text = viewModel.totalTime(section: indexPath.section, row: indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

}
