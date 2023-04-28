//
//  LoginViewModel.swift
//  SkillboxDrive
//
//  Created by Руслан Шигапов on 24.04.2023.
//

import Foundation

protocol LoginViewModelProtocol {
    func startPresentation(completion: @escaping() -> Void)
}

class LoginViewModel: LoginViewModelProtocol {
    
    func startPresentation(completion: @escaping() -> Void) {
        let thePresentationWasViewed = UserDefaults.standard.bool(forKey: "thePresentationWasViewed")
        if thePresentationWasViewed != true {
            completion()
        }
    }
}
