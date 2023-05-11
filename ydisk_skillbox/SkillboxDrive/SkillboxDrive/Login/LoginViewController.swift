//
//  LoginViewController.swift
//  SkillboxDrive
//
//  Created by Руслан Шигапов on 28.02.2023.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Private Properties
    private var viewModel: LoginViewModelProtocol! {
        didSet {
            viewModel.startPresentation {
                if let onboardingVC = storyboard?.instantiateViewController(
                    withIdentifier: "OnboardingViewController") as? OnboardingViewController {
                    present(onboardingVC, animated: true)
                }
            }
            viewModel.tokenWasReceived = { [unowned self] in
                performSegue(withIdentifier: "toRecents", sender: nil)
            }
        }
    }
    
    // MARK: - Override Methods
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel = LoginViewModel()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let authViewController = segue.destination as? AuthViewController else { return }
        authViewController.delegate = sender as? AuthViewControllerDelegate
    }
    
    // MARK: - IB Actions
    @IBAction func logOnButtonPressed() {
        viewModel.checkToken { isExist in
            if isExist {
                performSegue(withIdentifier: "toRecents", sender: nil)
            } else {
                performSegue(withIdentifier: "toAuth", sender: viewModel)
            }
        }
    }
}
