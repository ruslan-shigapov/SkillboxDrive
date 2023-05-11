//
//  DetailsViewModel.swift
//  SkillboxDrive
//
//  Created by Руслан Шигапов on 11.05.2023.
//

import Foundation

protocol DetailsViewModelProtocol {
    init(item: Item)
}

class DetailsViewModel: DetailsViewModelProtocol {
    
    private let item: Item
    
    required init(item: Item) {
        self.item = item
    }
}
