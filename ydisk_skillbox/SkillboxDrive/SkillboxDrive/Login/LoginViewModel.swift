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
    func startPresentation(completion: () -> Void)
    func checkToken(completion: (_ isExist: Bool) -> Void)
}

class LoginViewModel: LoginViewModelProtocol {
    
    var tokenWasReceived: (() -> Void)?
    
    func startPresentation(completion: () -> Void) {
        if UserDefaults.standard.bool(forKey: "presentationWasViewed") != true {
            completion()
        }
    }
    
    func checkToken(completion: (_ isExist: Bool) -> Void) {
        if UserDefaults.standard.string(forKey: "token") != nil {
            completion(true)
        } else {
            completion(false)
        }
    }
}
