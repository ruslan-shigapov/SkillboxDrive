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
    func startPresentation(completion: @escaping () -> Void)
    func checkToken(completion: @escaping (Bool) -> Void)
}

class LoginViewModel: LoginViewModelProtocol {
    
    var tokenWasReceived: (() -> Void)?
    
    func startPresentation(completion: @escaping () -> Void) {
        let thePresentationWasViewed = UserDefaults.standard.bool(forKey: "presentationWasViewed")
        if thePresentationWasViewed != true {
            completion()
        }
    }
    
    func checkToken(completion: @escaping (Bool) -> Void) {
        if let _ = UserDefaults.standard.string(forKey: "token") {
            completion(true)
        } else {
            completion(false)
        }
    }
}
