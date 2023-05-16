//
//  DetailsViewModel.swift
//  SkillboxDrive
//
//  Created by Руслан Шигапов on 11.05.2023.
//

import Foundation

protocol DetailsViewModelProtocol {
    var itemData: Data? { get }
    var request: URLRequest? { get }
    var name: String { get }
    var preview: String? { get }
    var created: String { get }
    var path: String { get }
    var itemType: ItemType { get }
    init(item: Item)
    func fetchItem(completion: @escaping () -> Void)
}

class DetailsViewModel: DetailsViewModelProtocol {
    
    var itemData: Data?
    var request: URLRequest?
    
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
    var itemType: ItemType {
        let pathExtension = NSString(string: path).pathExtension
        if ["jpg", "png", "jpeg", "gif", "bmp"].contains(pathExtension) {
            return .image
        } else if pathExtension == "pdf" {
            return .pdf
        } else {
            return .document
        }
    }
    
    private let item: Item
    
    required init(item: Item) {
        self.item = item
    }
    
    func fetchItem(completion: @escaping () -> Void) {
        guard var urlComponents = URLComponents(string: Link.Details.rawValue) else { return }
        urlComponents.queryItems = [URLQueryItem(name: "path", value: path)]
        guard let url = urlComponents.url else { return }
        NetworkManager.shared.fetch(ItemLink.self, from: url) { [unowned self] result in
            switch result {
            case .success(let link):
                guard let url = URL(string: link.href) else { return }
                fetchItemData(from: url) {
                    completion()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetchItemData(from url: URL, completion: @escaping () -> Void) {
        switch itemType {
        case .image, .pdf:
            NetworkManager.shared.fetchData(from: url) { [unowned self] result in
                switch result {
                case .success(let data):
                    itemData = data
                    completion()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case .document:
            request = URLRequest(url: url)
            completion()
        }
    }
}
