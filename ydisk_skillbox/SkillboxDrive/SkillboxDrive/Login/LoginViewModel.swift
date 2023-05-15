//
//  LoginViewModel.swift
//  SkillboxDrive
//
//  Created by Руслан Шигапов on 24.04.2023.
//

import Foundation

protocol AuthViewControllerDelegate {
    var tokenWasReceived: (() -> Void)? { get set }
    var tokenIsExist: Bool { get }
}

protocol LoginViewModelProtocol: AuthViewControllerDelegate {
    func startPresentation(completion: () -> Void)
}

class LoginViewModel: LoginViewModelProtocol {
    
    var tokenWasReceived: (() -> Void)?
    
    var tokenIsExist: Bool {
        UserDefaults.standard.string(forKey: "token") != nil
    }
    
    func startPresentation(completion: () -> Void) {
        if UserDefaults.standard.bool(forKey: "presentationWasViewed") != true {
            completion()
        }
    }
}
