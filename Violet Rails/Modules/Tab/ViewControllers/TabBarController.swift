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
        
        Task {
            try await getTabs(endpoint: VisitableViewManager.shared.selectedURL.absoluteString)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }

    func setupTabs(endpoint: String){
        var items: [UINavigationController] = navigationTabs.enumerated().compactMap({ index, tab in
            var url: URL?
            
            if tab.path.prefix(1) == "/" {
                url = URL(string: "\(endpoint)\(tab.path)")
            } else {
                url = URL(string: "https://\(tab.path)")
            }
            
            guard let url = url else { return nil }
            
            let vc = BaseVisitableViewController(url: url)
            
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
    
    func getTabs(endpoint: String) async throws {
        do {
            let config = try await configService.getConfig(endpoint: endpoint)
            
            navigationTabs = config.data.attributes.properties.tabNavigation.map({ tab in
                    .init(title: tab.label, path: tab.path)
            })
            
            setupTabs(endpoint: endpoint)
        } catch {
            throw error
        }
    }
}
