//
//  Response.swift
//  SkillboxDrive
//
//  Created by Руслан Шигапов on 09.03.2023.
//

import Foundation

struct Response: Codable {
    let items: [Item]?
}

struct Item: Codable {
    let name: String?
    let preview: String?
    let created: String?
    let size: Int64?
    
    static func getItems(from files: [File]) -> [Item] {
        var items: [Item] = []
        for file in files {
            let item = Item(
                name: file.name,
                preview: file.preview,
                created: file.created,
                size: file.size
            )
            items.append(item)
        }
        return items
    }
}
