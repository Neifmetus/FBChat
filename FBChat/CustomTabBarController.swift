//
//  CustomTabBarController.swift
//  FBChat
//
//  Created by e.bateeva on 09.08.17.
//  Copyright © 2017 Катя. All rights reserved.
//

import Foundation
import UIKit

class CustomTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup our custom view controllers
        let layout = UICollectionViewFlowLayout()
        let friendsController = FriendsController(collectionViewLayout: layout)
        let recentMessagesNavController = UINavigationController(rootViewController: friendsController)
        recentMessagesNavController.tabBarItem.title = "Recent"
        recentMessagesNavController.tabBarItem.image = UIImage(named: "recent")
        
        let viewController = UIViewController()
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.title = "Calls"
        navController.tabBarItem.image = UIImage(named: "calls")
        
        viewControllers = [recentMessagesNavController,
                           createDummyNavControllerWith(title: "Calls", imageName: "calls"),
                           createDummyNavControllerWith(title: "Groups", imageName: "groups"),
                           createDummyNavControllerWith(title: "People", imageName: "people"),
                           createDummyNavControllerWith(title: "Settings", imageName: "settings")]
    }
    
    private func createDummyNavControllerWith(title: String, imageName: String) -> UINavigationController {
        let viewController = UIViewController()
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(named: imageName)
        
        return navController
    }
}
