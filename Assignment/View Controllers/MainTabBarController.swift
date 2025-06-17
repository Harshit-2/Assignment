//
//  MainTabBarController.swift
//  Assignment
//
//  Created by Harshit ‎ on 6/16/25.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    private func setupTabBar() {
        tabBar.tintColor = Constants.Colors.primaryColor
        
        let homeVC = HomeViewController()
        let homeNav = UINavigationController(rootViewController: homeVC)
        homeNav.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: Constants.Images.homeIcon), tag: 0)
        
        let reportVC = ReportViewController()
        let reportNav = UINavigationController(rootViewController: reportVC)
        reportNav.tabBarItem = UITabBarItem(title: "Report", image: UIImage(systemName: Constants.Images.reportIcon), tag: 1)
        
        let imageVC = ImageViewController()
        let imageNav = UINavigationController(rootViewController: imageVC)
        imageNav.tabBarItem = UITabBarItem(title: "Images", image: UIImage(systemName: Constants.Images.imageIcon), tag: 2)
        
        let settingsVC = SettingsViewController()
        let settingsNav = UINavigationController(rootViewController: settingsVC)
        settingsNav.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: Constants.Images.settingsIcon), tag: 3)
        
        viewControllers = [homeNav, reportNav, imageNav, settingsNav]
    }
}
