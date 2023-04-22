//
//  Response.swift
//  SkillboxDrive
//
//  Created by Руслан Шигапов on 09.03.2023.
//

import Foundation

struct Response: Codable {
    let items: [File]?
}

struct File: Codable {
    let name: String?
    let preview: String?
    let size: Int64?
}
