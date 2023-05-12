//
//  Item.swift
//  SkillboxDrive
//
//  Created by Руслан Шигапов on 09.03.2023.
//

import Foundation

struct ItemList: Codable {
    let items: [Item]
}

struct Item: Codable {
    let _embedded: ItemList?
    let name: String?
    let preview: String?
    let created: String?
    let type: String?
    let size: Int64?
    
    static func getItems(from files: [File]) -> [Item] {
        var items: [Item] = []
        for file in files {
            let item = Item(
                _embedded: nil,
                name: file.name,
                preview: file.preview,
                created: file.created,
                type: file.type,
                size: file.size
            )
            items.append(item)
        }
        return items
    }
}
