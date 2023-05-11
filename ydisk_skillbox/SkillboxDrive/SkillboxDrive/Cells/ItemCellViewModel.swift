//
//  BrowseItemCellViewModel.swift
//  SkillboxDrive
//
//  Created by Руслан Шигапов on 07.05.2023.
//

import UIKit

protocol ItemCellViewModelProtocol {
    var imageData: Data? { get }
    var name: String { get }
    var information: String { get }
    var preview: String? { get }
    init(item: Item)
    func fetchImage(completion: @escaping () -> Void)
}

class ItemCellViewModel: ItemCellViewModelProtocol {
    
    var imageData: Data?
    
    var name: String {
        guard let name = item.name else { return "Unknown name" }
        return NSString(string: name).deletingPathExtension
    }
    var size: String {
        String(format: "%.1f", Double(item.size) / 1024) + " kb"
    }
    var created: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
        guard let created = item.created else { return "" }
        guard let date = formatter.date(from: created) else { return "" }
        formatter.dateFormat = "dd.MM.yy  HH:mm"
        return formatter.string(from: date)
    }
    var information: String {
        "\(size)  \(created)"
    }
    var preview: String? {
        item.preview
    }
    
    private let item: Item
    
    required init(item: Item) {
        self.item = item
    }
    
    func fetchImage(completion: @escaping () -> Void) {
        guard let previewURL = preview else { return }
        NetworkManager.shared.fetchImageData(from: previewURL) { [weak self] result in
            switch result {
            case .success(let imageData):
                self?.imageData = imageData
                completion()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
