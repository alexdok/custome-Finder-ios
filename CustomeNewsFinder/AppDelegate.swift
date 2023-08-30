//
//  AppDelegate.swift
//  CustomeNewsFinder
//
//  Created by алексей ганзицкий on 09.02.2023.
//

import UIKit


    @main
    class AppDelegate: UIResponder, UIApplicationDelegate {
        
        var window: UIWindow?
        
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            
            let navigationController = UINavigationController.init(rootViewController: TableViewController())
            let networkManager = NetworkManagerImpl(mapper: MapNewsToObjectImpl(), requestBilder: RequestBuilderImpl())
            let viewModel = TableViewModel(networkManager: networkManager)
            
            if let rootViewController = navigationController.viewControllers.first as? TableViewController {
                rootViewController.viewModel = viewModel
            }
            
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.rootViewController = navigationController
            window?.makeKeyAndVisible()
    
            return true
        }
    }

