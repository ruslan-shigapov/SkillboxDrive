//
//  OnboardingPage.swift
//  SkillboxDrive
//
//  Created by Руслан Шигапов on 18.04.2023.
//

import UIKit

enum OnboardingPage: Int {
    case first
    case second
    case third
    
    var image: UIImage? {
        UIImage(named: "Picture \(self.rawValue)")
    }
    
    var description: String {
        switch self {
        case .first:
            return Constants.Text.firstOnboardingScreen
        case .second:
            return Constants.Text.secondOnboardingScreen
        case .third:
            return Constants.Text.thirdOnboardingScreen
        }
    }
}
