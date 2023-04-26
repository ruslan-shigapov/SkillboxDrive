//
//  LoginViewController.swift
//  SkillboxDrive
//
//  Created by Руслан Шигапов on 28.02.2023.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Private Properties
    private var viewModel: LoginViewModelProtocol!
        
    // MARK: - Override Methods
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel = LoginViewModel()
        viewModel.startPresentation { [unowned self] in
            if let onboardingVC = self.storyboard?.instantiateViewController(
                withIdentifier: "OnboardingViewController") as? OnboardingViewController {
                
                self.present(onboardingVC, animated: true)
            }
        }
    }
    
    // MARK: - IB Actions
    @IBAction func enterButtonPressed() {
        if let _ = viewModel.token {
            if let tabBarController = self.storyboard?.instantiateViewController(
                withIdentifier: "TabBarController") as? UITabBarController {
                
                present(tabBarController, animated: true)
            }
        } else {
            if let authViewController = self.storyboard?.instantiateViewController(
                withIdentifier: "AuthViewController") as? AuthViewController {
                
                present(authViewController, animated: true)
            }
        }
    }
}
