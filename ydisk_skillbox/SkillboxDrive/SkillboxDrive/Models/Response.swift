//
//  Response.swift
//  SkillboxDrive
//
//  Created by Руслан Шигапов on 09.03.2023.
//

import Foundation

struct Response: Codable {
    let items: [Item]
}

struct Item: Codable {
    let name: String
    let preview: String?
    let created: String
    let size: Int64
}
