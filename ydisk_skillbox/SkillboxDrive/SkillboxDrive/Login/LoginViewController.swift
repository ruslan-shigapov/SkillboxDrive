//
//  LoginViewController.swift
//  SkillboxDrive
//
//  Created by Руслан Шигапов on 28.02.2023.
//

import UIKit

class LoginViewController: UIViewController {
    
    private var token = ""
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startPresentation()
    }
    
    @IBAction func buttonPressed() {
        guard !token.isEmpty else {
            let requestTokenViewController = AuthViewController()
            requestTokenViewController.delegate = self
            requestTokenViewController.modalPresentationStyle = .fullScreen
            present(requestTokenViewController, animated: true)
            return
        }
        performSegue(withIdentifier: "toFiles", sender: nil)
    }
    
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

extension LoginViewController: AuthViewControllerDelegate {
    
    func handleTokenChanged(token: String) {
        self.token = token
    }
}
