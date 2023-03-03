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
        let navbarHeight = ((self.view.frame.height / 100) * 9.5) + 1
        tabBar.frame = CGRect(x: 0, y: self.view.frame.height - navbarHeight, width: self.view.frame.width, height: 49)
        tabBar.items = [home, blog, forum]
        self.view.addSubview(tabBar)
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



