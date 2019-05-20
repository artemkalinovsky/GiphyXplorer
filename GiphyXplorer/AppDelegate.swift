//
//  AppDelegate.swift
//  GiphyXplorer
//
//  Created by Artem Kalinovsky on 4/30/19.
//  Copyright © 2019 Artem Kalinovsky. All rights reserved.
//

import UIKit
import Nuke

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        ImagePipeline.Configuration.isAnimatedImageDataEnabled = true
        return true
    }

}
