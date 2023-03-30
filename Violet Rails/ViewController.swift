//
//  ViewController.swift
//  Violet Rails
//
//  Created by Shashike Jayatunge on 2022-06-26.
//

import UIKit

class ViewController: UINavigationController, UITabBarDelegate {
    let tabBar = UITabBar()
    let home = UITabBarItem(title: "Home",image: .checkmark, tag: 0)
    let blog = UITabBarItem(title: "Blog", image: .checkmark, tag: 1)
    let forum = UITabBarItem(title: "Forum", image: .checkmark, tag: 2)
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        tabBar.items = [home, blog, forum]
        
        self.view.addSubview(tabBar)
        
        NSLayoutConstraint.activate([
            tabBar.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            tabBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tabBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
    }

}

extension UIApplication {
    var statusBarView: UIView? {
        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}



