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
    func fetchLink(completion: @escaping () -> Void)
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
    
    required init(item: Item) {
        self.item = item
    }
    
    func fetchLink(completion: @escaping () -> Void) {
        guard var urlComponents = URLComponents(string: Link.Details.rawValue) else { return }
        urlComponents.queryItems = [URLQueryItem(name: "path", value: path)]
        guard let url = urlComponents.url else { return }
        NetworkManager.shared.fetch(ItemLink.self, from: url) { [unowned self] result in
            switch result {
            case .success(let link):
                fetchData(from: link.href) {
                    completion()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetchData(from url: String, completion: @escaping () -> Void) {
        guard let url = URL(string: url) else { return }
        NetworkManager.shared.fetchData(from: url) { [unowned self] result in
            switch result {
            case .success(let data):
                itemData = data
                completion()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
