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
    
    var previousIndexPath: IndexPath? = nil
    var previousCell: RecordListCell? = nil
    
    var timeObserver: Any?
    
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
        recordListView.separatorStyle = .singleLine
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
        
        cell.player = player
        cell.delegate = self
        cell.timeObserver = timeObserver
        cell.totalTimeLabel.text = viewModel.totalTime(section: indexPath.section, row: indexPath.row)
        
        return cell
    }
}

// MARK: Logic for TableView Cell
extension RecordListViewController {
    private func updatePlayButtonUI(sender: UIButton) {
        let config = UIImage.SymbolConfiguration(pointSize: 35)
        if player.isPlaying {
            sender.setImage(UIImage(systemName: "pause.fill", withConfiguration: config), for: .normal)
        } else {
            sender.setImage(UIImage(systemName: "play.fill", withConfiguration: config), for: .normal)
        }
    }
    
    private func addPeriodicTimeObserver(cell: RecordListCell) {
        timeObserver = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.01, preferredTimescale: 100),queue: .main) { [weak self] time in
            guard let self = self else { return }
            self.updateTime(cell: cell, time: time)
            if self.player.currentTime == self.player.totalDurationTime {
                self.playEndedOrItemChanged(cell: cell)
            }
        }
    }
    
    private func updateTime(cell: RecordListCell, time: CMTime) {
        cell.currentTimeLabel.text = viewModel.secondToString(sec: player.currentTime)
        
        if cell.isSeeking == false {
            cell.slider.value = Float(player.currentTime/player.totalDurationTime)
        }
    }
    
    private func playEndedOrItemChanged(cell: RecordListCell) {
        if timeObserver != nil {
            player.removeTimeObserver(observer: timeObserver!)
        }
        
        player.pause()
        player.seek(to: CMTime(seconds: 0, preferredTimescale: 100))
        
        self.timeObserver = nil
        cell.currentTimeLabel.text = "00:00"
        updatePlayButtonUI(sender: cell.playButton)
        cell.slider.value = 0.0
    }
}

extension RecordListViewController: RecordListCellDelegate {
    func playButtonTapped(cell: RecordListCell) {
        guard let indexPath = recordListView.indexPath(for: cell),
              let url = viewModel.itemURL(section: indexPath.section, row: indexPath.row) else { return }
        
        if previousIndexPath != nil {
            previousCell = recordListView.cellForRow(at: previousIndexPath!) as? RecordListCell
        }
        print(previousIndexPath == indexPath)
        if previousIndexPath == indexPath {
            if player.isPlaying {
                player.pause()
            } else {
                player.play()
            }
        } else {
            if previousCell != nil {
                playEndedOrItemChanged(cell: previousCell!)
            }
            player.replaceCurrentItem(with: AVPlayerItem(url: url))
            if player.isPlaying {
                player.pause()
            } else {
                player.play()
            }
            addPeriodicTimeObserver(cell: cell)
            previousIndexPath = indexPath
        }
        
        updatePlayButtonUI(sender: cell.playButton)
    }
}
