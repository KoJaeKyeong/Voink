//
//  TabBarController.swift
//  Voink
//
//  Created by Jae Kyeong Ko on 2022/05/03.
//

import UIKit
import SnapKit

final class TabBarController: UITabBarController {
    
    private let mapViewController = MapViewController()
    private let emptyViewController = UIViewController()
    private let recordListViewController = RecordListViewController()
        
    private lazy var recordButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        configureAttribute()
        configureLayout()
    }
    
    private func configureAttribute() {
        view.backgroundColor = .systemBackground
        
        mapViewController.tabBarItem = UITabBarItem(title: "map", image: UIImage(systemName: "map"), tag: 0)
        emptyViewController.tabBarItem = UITabBarItem(title: nil, image: nil, tag: 1)
        recordListViewController.tabBarItem = UITabBarItem(title: "list", image: UIImage(systemName:"list.bullet"), tag: 2)
        viewControllers = [mapViewController, emptyViewController, recordListViewController]
        
        tabBar.items?[1].isEnabled = false
        
        recordButton.setImage(UIImage(systemName: "record.circle"), for: .normal)
        recordButton.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 37), forImageIn: .normal)
        recordButton.tintColor = .systemRed
        recordButton.addTarget(self, action: #selector(recordButtonTapped), for: .touchUpInside)
    }
    
    private func configureLayout() {
        tabBar.addSubview(recordButton)
        
        recordButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    @objc private func recordButtonTapped() {
        let recordViewController = RecordViewController()
        recordViewController.modalPresentationStyle = .overFullScreen
        present(recordViewController, animated: true)
    }
}
