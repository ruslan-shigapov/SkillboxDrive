//
//  DetailsViewModel.swift
//  SkillboxDrive
//
//  Created by Руслан Шигапов on 11.05.2023.
//

import Foundation

protocol DetailsViewModelProtocol {
    var itemData: Data? { get }
    var name: String { get }
    var preview: String? { get }
    var created: String { get }
    var path: String { get }
    var type: String { get }
    init(item: Item)
    func downloadItem(completion: @escaping () -> Void)
}

class DetailsViewModel: DetailsViewModelProtocol {
    
    var itemData: Data?
    
    var name: String {
        guard let name = item.name else { return "Unknown name" }
        return NSString(string: name).deletingPathExtension
    }
    var preview: String? {
        item.preview
    }
    var created: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
        guard let created = item.created else { return "" }
        guard let date = formatter.date(from: created) else { return "" }
        formatter.dateFormat = "dd.MM.yy HH:mm"
        return formatter.string(from: date)
    }
    var path: String {
        item.path ?? ""
    }
    var type: String {
        item.type ?? ""
    }
    
    private let item: Item
    private var link: String?
    
    required init(item: Item) {
        self.item = item
    }
    
    func downloadItem(completion: @escaping () -> Void) {
        fetchLink()
        guard let link else { return }
        NetworkManager.shared.fetchData(from: link) { [weak self] result in
            switch result {
            case .success(let itemData):
                self?.itemData = itemData
                completion()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetchLink() {
        NetworkManager.shared.fetch(
            ItemLink.self,
            from: Link.Details.rawValue + "\(path)"
        ) { [weak self] result in
            switch result {
            case .success(let link):
//                print(link.href) TODO: Format URL
                self?.link = link.href
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
