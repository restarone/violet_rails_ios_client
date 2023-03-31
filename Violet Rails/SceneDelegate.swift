//
//  SceneDelegate.swift
//  Violet Rails
//
//  Created by Shashike Jayatunge on 2022-06-26.
//

import UIKit
import Turbo
import WebKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private lazy var navigationController = ViewController()
    let viewController = VisitableViewController()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        window!.rootViewController = navigationController
        
        navigationController.tabBar.delegate = self
        navigationController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.backgroundColor = .gray
        
        navigationController.navigationBar.standardAppearance = navigationBarAppearance
        navigationController.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        
        navigationController.pushViewController(viewController, animated: true)
        
        visit(url: URL(string: Link.ROOT)!)
    }
    
    private func visit(url: URL) {
        viewController.visitableURL = url
        session.visit(viewController)
    }
    
    private lazy var session: Session = {
        let configuration = WKWebViewConfiguration()
        configuration.applicationNameForUserAgent = "VioletRailsiOS"
        let session = Session(webViewConfiguration: configuration)
        session.delegate = self
        return session
    }()
}

extension SceneDelegate: SessionDelegate {
    func sessionWebViewProcessDidTerminate(_ session: Session) {
    }
    
    
    func session(_ session: Session, didProposeVisit proposal: VisitProposal) {
        visit(url: proposal.url)
    }
    
    func session(_ session: Session, didFailRequestForVisitable visitable: Visitable, error: Error) {
        print("didFailRequestForVisitable: \(error)")
    }
}


extension SceneDelegate: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if let selectedTab = navigationTabs.first(where: { $0.title == item.title }),
           let url = URL(string: "\(Link.ROOT)\(selectedTab.path)"){
            visit(url: url)
        } else {
            print("unhandled tab bar selection error")
        }
    }
}
