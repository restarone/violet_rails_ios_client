//
//  SceneDelegate.swift
//  Violet Rails
//
//  Created by Shashike Jayatunge on 2022-06-26.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    var tabBarController: TabBarController?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        
        window?.rootViewController = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
        window?.makeKeyAndVisible()
        
        tabBarController = TabBarController()
        
        guard let tabBarController = tabBarController else { return }
        
        tabBarController.setupTabs(endpoint: App.ENDPOINT)
        
        VisitableViewManager.shared.registerOnLoadListener { [weak self] in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.window?.rootViewController = self.tabBarController
                self.window?.makeKeyAndVisible()
                
                VisitableViewManager.shared.removeOnLoadListener()
            }
        }
    }
}
