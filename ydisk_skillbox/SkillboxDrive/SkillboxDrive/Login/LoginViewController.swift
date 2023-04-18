//
//  LoginViewController.swift
//  SkillboxDrive
//
//  Created by Руслан Шигапов on 28.02.2023.
//

import UIKit

class LoginViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startPresentation()
    }
    
    @IBAction func buttonPressed() {
        
    }
    
    private func startPresentation() {
        let isFirstLaunch = UserDefaults.standard.bool(forKey: "isFirstLaunch")
        if isFirstLaunch == false {
            if let onboardingVC = storyboard?.instantiateViewController(
                withIdentifier: "OnboardingViewController") as? OnboardingViewController {
                present(onboardingVC, animated: true)
            }
        }
    }
}

