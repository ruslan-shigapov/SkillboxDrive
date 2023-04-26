//
//  LoginViewModel.swift
//  SkillboxDrive
//
//  Created by Руслан Шигапов on 24.04.2023.
//

import Foundation

protocol LoginViewModelProtocol {
    var token: String? { get }
    func startPresentation(completion: @escaping() -> Void)
}

class LoginViewModel: LoginViewModelProtocol {
    var token: String? {
        DataManager.shared.token
    }
    func startPresentation(completion: @escaping() -> Void) {
        let thePresentationWasViewed = UserDefaults.standard.bool(forKey: "thePresentationWasViewed")
        if thePresentationWasViewed != true {
            completion()
        }
    }
}
