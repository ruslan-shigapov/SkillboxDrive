//
//  ItemCellViewModel.swift
//  SkillboxDrive
//
//  Created by Руслан Шигапов on 24.04.2023.
//

import UIKit

protocol ItemCellViewModelProtocol {
    var name: String? { get }
    var information: String { get }
    var preview: String? { get }
    init(item: Item)
}

class ItemCellViewModel: ItemCellViewModelProtocol {
    var name: String? {
        item.name
    }
    var information: String {
        item.information
    }
    var preview: String? {
        item.preview
    }
    private let item: Item
    required init(item: Item) {
        self.item = item
    }
}
