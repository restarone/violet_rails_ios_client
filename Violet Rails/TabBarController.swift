//
//  TabBarController.swift
//  Violet Rails
//
//  Created by Joses Solmaximo on 23/04/23.
//

import UIKit
import WebKit
import Turbo

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    private var navigationBarAppearance: UINavigationBarAppearance {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.backgroundColor = .gray
        
        return navigationBarAppearance
    }
    
    private var tabBarAppearance: UITabBarAppearance {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithDefaultBackground()
        
        return tabBarAppearance
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        
        tabBar.scrollEdgeAppearance = tabBarAppearance
        tabBar.standardAppearance = tabBarAppearance
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let items = navigationTabs.enumerated().map({ index, tab in
            let visitableController = BaseVisitableViewController(url: URL(string: "\(App.ENDPOINT)\(tab.path)")!)
            let navigationController = UINavigationController(rootViewController: visitableController)
            
            navigationController.navigationBar.standardAppearance = navigationBarAppearance
            navigationController.navigationBar.scrollEdgeAppearance = navigationBarAppearance
            
            navigationController.tabBarItem = UITabBarItem(title: tab.title, image: .checkmark, tag: index)
            
            return navigationController
        })
        
        self.viewControllers = items
    }

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
}
