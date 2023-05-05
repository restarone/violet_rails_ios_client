//
//  TabBarController.swift
//  Violet Rails
//
//  Created by Joses Solmaximo on 05/05/23.
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

    private var navigationTabs: [NavigationTab] = []

    private let configService = ConfigService()

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self

        tabBar.scrollEdgeAppearance = tabBarAppearance
        tabBar.standardAppearance = tabBarAppearance
        
        getTabs(endpoint: VisitableViewManager.shared.selectedURL)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }

    func setupTabs(){
        var items = navigationTabs.enumerated().map({ index, tab in
            let vc = BaseVisitableViewController(url: URL(string: "\(App.ENDPOINT)\(tab.path)")!)
            let navigationController = UINavigationController(rootViewController: vc)

            navigationController.navigationBar.standardAppearance = navigationBarAppearance
            navigationController.navigationBar.scrollEdgeAppearance = navigationBarAppearance

            navigationController.tabBarItem = UITabBarItem(title: tab.title, image: .checkmark, tag: index)

            return navigationController
        })

        var appItem: UINavigationController {
            let vc = AppPickerViewController()
            let navigationController = UINavigationController(rootViewController: vc)

            navigationController.navigationBar.standardAppearance = navigationBarAppearance
            navigationController.navigationBar.scrollEdgeAppearance = navigationBarAppearance

            navigationController.tabBarItem = UITabBarItem(title: "Apps", image: .add, tag: items.count)

            return navigationController
        }

        items.append(appItem)

        self.viewControllers = items
    }
    
    func getTabs(endpoint: String){
        VisitableViewManager.shared.setSelectedURL(endpoint)
        
        Task {
            do {
                let config = try await configService.getConfig(endpoint: endpoint)
                
                navigationTabs = config.data.attributes.properties.tabNavigation.map({ tab in
                        .init(title: tab.label, path: tab.path)
                })
                
                setupTabs()
            } catch {
              
            }
        }
    }
}
