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
        
    var definition: String {
        switch self {
        case .first:
            return "Теперь все ваши документы в одном месте"
        case .second:
            return "Доступ к файлам без интернета"
        case .third:
            return "Делитесь вашими файлами с другими"
        }
    }
}
