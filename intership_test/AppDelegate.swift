//
//  AppDelegate.swift
//  intership_test
//
//  Created by Костина Вероника  on 31.10.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        createWindow()
        return true
    }
    
    private func createWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        let rootVc = MainViewController()
        window?.rootViewController = rootVc
        window?.makeKeyAndVisible()
    }
}

