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
        emptyViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "record.circle"), tag: 1)
        recordListViewController.tabBarItem = UITabBarItem(title: "list", image: UIImage(systemName:"list.bullet"), tag: 2)
        
        if tabBarItem.tag == 1 {
            UITabBar.appearance().tintColor = .systemRed
        }
        
        viewControllers = [mapViewController, emptyViewController, recordListViewController]
    }
    
    private func configureLayout() {
        
    }
}
