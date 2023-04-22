//
//  LoginViewController.swift
//  SkillboxDrive
//
//  Created by Руслан Шигапов on 28.02.2023.
//

import UIKit

class LoginViewController: UIViewController {
        
    // MARK: - Override Methods
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startPresentation()
    }
    
    // MARK: - Private Methods
    private func startPresentation() {
        let thePresentationWasViewed = UserDefaults.standard.bool(forKey: "thePresentationWasViewed")
        if thePresentationWasViewed != true {
            if let onboardingVC = storyboard?.instantiateViewController(
                withIdentifier: "OnboardingViewController") as? OnboardingViewController {
                
                present(onboardingVC, animated: true)
            }
        }
    }
}
