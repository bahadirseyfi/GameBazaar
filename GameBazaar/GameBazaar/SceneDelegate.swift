//
//  SceneDelegate.swift
//  GameBazaar
//
//  Created by bahadir on 24.05.2021.
//

import UIKit
import CoreAPI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeViewController = storyboard.instantiateViewController(identifier: "HomeViewController") as! HomeViewController
        let wishListController = storyboard.instantiateViewController(identifier: "WishlistViewController") as! WishlistViewController
        
        let homeViewModel = HomeViewModel(networkManager: NetworkManager())
        homeViewController.viewModel = homeViewModel
        
        let wishViewModel = WishlistViewModel()
        wishListController.viewModel = wishViewModel
        
        let homeNavigationController = UINavigationController(rootViewController: homeViewController)
        let wishListNavigationController = UINavigationController(rootViewController: wishListController)
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [homeNavigationController, wishListNavigationController]
        
        let tabItemHome = UITabBarItem(title: "Games", image: UIImage(systemName: "gamecontroller"), tag: 0)
        let tabItemWishList = UITabBarItem(title: "Wishlist", image: UIImage(systemName: "gift"), tag: 1)
        
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().barTintColor = UIColor(displayP3Red: 26/255, green: 26/255, blue: 26/255, alpha: 1)
        UINavigationBar.appearance().isTranslucent = true

        UITabBar.appearance().barTintColor = UIColor(displayP3Red: 26/255, green: 26/255, blue: 26/255, alpha: 1)
        UITabBar.appearance().isTranslucent = true
        UITabBar.appearance().tintColor = .white
        
        wishListNavigationController.tabBarItem = tabItemWishList
        homeNavigationController.tabBarItem = tabItemHome
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

