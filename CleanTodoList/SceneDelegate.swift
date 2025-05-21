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
        
        let todoListView = TodoListView()
        let doneListView = DoneListView()
        let todoCoreData = TodoCoreData()
        let todoRepository = TodoRepository(coreDataManager: todoCoreData)
        let todoUseCase = TodoUseCase(todoRepository: todoRepository)
        let todoViewModel = TodoViewModel(useCase: todoUseCase)
        
        let todoViewController = UINavigationController(rootViewController: TodoListViewController(todoListView: todoListView, todoViewModel: todoViewModel))
        todoViewController.tabBarItem = UITabBarItem(title: "Todo", image: UIImage(systemName: "list.bullet"), tag: 0)
        
        let doneViewController = UINavigationController(rootViewController: DoneListViewController(doneListView: doneListView, todoViewModel: todoViewModel))
        doneViewController.tabBarItem = UITabBarItem(title: "Done", image: UIImage(systemName: "checkmark.circle"), tag: 1)
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [todoViewController, doneViewController]
        
        window.rootViewController = tabBarController
        self.window = window
        window.makeKeyAndVisible()
    }

    
    
}

