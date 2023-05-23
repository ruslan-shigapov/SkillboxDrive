//
//  LoginViewModel.swift
//  SkillboxDrive
//
//  Created by Руслан Шигапов on 24.04.2023.
//

import Foundation

protocol AuthViewControllerDelegate {
    var tokenWasReceived: (() -> Void)? { get set }
}

protocol LoginViewModelProtocol: AuthViewControllerDelegate {
    var tokenIsExist: Bool { get }
    func showPresentation(completion: () -> Void)
}

class LoginViewModel: LoginViewModelProtocol {
    
    var tokenWasReceived: (() -> Void)?
    
    var tokenIsExist: Bool {
        UserDefaults.standard.string(forKey: "token") != nil
    }
    
    func showPresentation(completion: () -> Void) {
        if UserDefaults.standard.bool(forKey: "presentationWasViewed") != true {
            completion()
        }
    }
}
