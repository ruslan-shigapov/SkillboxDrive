//
//  ItemCellViewModel.swift
//  SkillboxDrive
//
//  Created by Руслан Шигапов on 24.04.2023.
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
        NSString(string: item.name).deletingPathExtension
    }
    var size: String {
        String(format: "%.1f", Double(item.size) / 1024)
    }
    var created: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
        guard let date = formatter.date(from: item.created) else { return "" }
        formatter.dateFormat = "dd.MM.yy  HH:mm"
        return formatter.string(from: date)
    }
    var information: String {
        "\(size) кб  \(created)"
    }
    var preview: String? {
        item.preview
    }
    
    private let item: Item
    
    required init(item: Item) {
        self.item = item
    }
    
    func fetchImage(completion: @escaping() -> Void) {
        guard let previewURL = preview else { return }
        NetworkManager.shared.fetchData(from: previewURL) { [unowned self] result in
            switch result {
            case .success(let imageData):
                self.imageData = imageData
                completion()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
