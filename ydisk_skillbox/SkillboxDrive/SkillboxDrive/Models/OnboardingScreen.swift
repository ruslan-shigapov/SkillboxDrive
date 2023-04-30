//
//  OnboardingScreen.swift
//  SkillboxDrive
//
//  Created by Руслан Шигапов on 18.04.2023.
//

import UIKit

enum OnboardingScreen: Int {
    case first
    case second
    case third
    
    var image: UIImage? {
        UIImage(named: "Picture \(self.rawValue)")
    }
    var description: String {
        switch self {
        case .first:
            return "Now all your documents is in one place"
        case .second:
            return "Access to files without the Internet"
        case .third:
            return "Share your files with other people"
        }
    }
}
