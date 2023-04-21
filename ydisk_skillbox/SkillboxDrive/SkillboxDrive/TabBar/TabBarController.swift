//
//  TabBarController.swift
//  SkillboxDrive
//
//  Created by Руслан Шигапов on 21.04.2023.
//

import UIKit

class TabBarController: UITabBarController {
    
    var token: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        selectedIndex = 1
        setupViewControllers()
        print(token ?? "no")
    }
    
    private func setupViewControllers() {
        guard let viewControllers = self.viewControllers else { return }
        viewControllers.forEach {
            if let recentsVC = $0 as? RecentsViewController {
                recentsVC.token = token
            }
        }
    }
}
