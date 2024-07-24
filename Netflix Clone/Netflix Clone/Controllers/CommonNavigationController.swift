//
//  CommonNavigationController.swift
//  Netflix Clone
//
//  Created by CharismaInfotainment on 03/05/23.
//

import Foundation
import UIKit

class CommonNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the default navigation bar style and tint color
        navigationBar.barStyle = .default
        navigationBar.tintColor = .systemBlue
    }
    
    // Push a new view controller onto the stack
    override func pushViewController(_ viewController: UIViewController, animated: Bool = true) {
        viewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        super.pushViewController(viewController, animated: animated)
    }
    
    // Pop the current view controller from the stack
    func popViewController(animated: Bool = true) {
        super.popViewController(animated: animated)
    }
    
    // Pop to the root view controller
    func popToRootViewController(animated: Bool = true) {
        super.popToRootViewController(animated: animated)
    }
    
    // Present a view controller modally
    override func present(_ viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        super.present(viewController, animated: animated, completion: completion)
    }
    
    // Dismiss the currently presented view controller
    override func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        super.dismiss(animated: animated, completion: completion)
    }
}
