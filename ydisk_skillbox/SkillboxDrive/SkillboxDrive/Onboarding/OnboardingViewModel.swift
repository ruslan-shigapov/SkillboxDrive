//
//  OnboardingViewModel.swift
//  SkillboxDrive
//
//  Created by Руслан Шигапов on 24.04.2023.
//

import Foundation

protocol OnboardingViewModelProtocol {
    var currentPage: OnboardingScreen { get }
    var viewModelDidChange: ((OnboardingViewModelProtocol) -> Void)? { get set }
    func goToNextPage(completion: @escaping () -> Void)
}

class OnboardingViewModel: OnboardingViewModelProtocol {
    
    var currentPage: OnboardingScreen = .first
    var viewModelDidChange: ((OnboardingViewModelProtocol) -> Void)?
    
    func goToNextPage(completion: @escaping () -> Void) {
        if currentPage == .first {
            currentPage = .second
            viewModelDidChange?(self)
        } else if currentPage == .second {
            currentPage = .third
            viewModelDidChange?(self)
        } else {
            UserDefaults.standard.set(true, forKey: "presentationWasViewed")
            completion()
        }
    }
}
