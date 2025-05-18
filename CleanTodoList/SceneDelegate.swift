//
//  SceneDelegate.swift
//  CleanTodoList
//
//  Created by hansol on 2025/05/18.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        let todoVC = UINavigationController(rootViewController: TodoListViewController())
        todoVC.tabBarItem = UITabBarItem(title: "Todo", image: UIImage(systemName: "list.bullet"), tag: 0)
        
        let doneVC = UINavigationController(rootViewController: DoneListViewController())
        doneVC.tabBarItem = UITabBarItem(title: "Done", image: UIImage(systemName: "checkmark.circle"), tag: 1)
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [todoVC, doneVC]
        
        window.rootViewController = tabBarController
        self.window = window
        window.makeKeyAndVisible()
    }

    
    
}

