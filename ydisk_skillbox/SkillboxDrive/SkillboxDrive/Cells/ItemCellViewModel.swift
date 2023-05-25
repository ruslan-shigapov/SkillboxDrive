//
//  BrowseItemCellViewModel.swift
//  SkillboxDrive
//
//  Created by Руслан Шигапов on 07.05.2023.
//

import UIKit

protocol ItemCellViewModelProtocol {
    var name: String { get }
    var preview: String? { get }
    var information: String { get }
    var created: String { get }
    var type: String { get }
    init(item: Item)
    func fetchImageData(completion: @escaping (Data) -> Void)
    func setupUI(completion: (Bool) -> Void)
}

class ItemCellViewModel: ItemCellViewModelProtocol {
        
    var name: String {
        guard let name = item.name else { return Constants.Text.unknownItemName }
        return NSString(string: name).deletingPathExtension
    }
    var preview: String? {
        item.preview
    }
    var information: String {
        "\(size)  \(created)"
    }
    var size: String {
        guard let size = item.size else { return Constants.Text.unknownItemSize }
        return String(format: "%.1f", Double(size) / 1024) + Constants.Text.itemSize
    }
    var created: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
        guard let created = item.created else { return "" }
        guard let date = formatter.date(from: created) else { return "" }
        formatter.dateFormat = "dd.MM.yy HH:mm"
        return formatter.string(from: date)
    }
    var type: String {
        item.type ?? ""
    }
    
    private let item: Item
    
    required init(item: Item) {
        self.item = item
    }
    
    func fetchImageData(completion: @escaping (Data) -> Void) {
        guard let url = preview else { return }
        NetworkManager.shared.fetchData(from: url) { result in
            switch result {
            case .success(let imageData):
                completion(imageData)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func setupUI(completion: (Bool) -> Void) {
        if type == "file" {
            completion(true)
        } else {
            completion(false)
        }
    }
}
