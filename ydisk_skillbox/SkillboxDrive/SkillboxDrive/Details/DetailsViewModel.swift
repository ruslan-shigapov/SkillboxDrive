//
//  DetailsViewModel.swift
//  SkillboxDrive
//
//  Created by Руслан Шигапов on 11.05.2023.
//

import Foundation
import Alamofire

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
    func deleteItem(completion: @escaping () -> Void)
    func shareItemLink(completion: @escaping (String?) -> Void)
    func renameItem(to name: String, completion: @escaping () -> Void)
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
        guard var urlComponents = URLComponents(string: Link.toDetails.rawValue) else { return }
        urlComponents.queryItems = [URLQueryItem(name: "path", value: path)]
        guard let url = urlComponents.url else { return }
        NetworkManager.shared.fetch(ItemLink.self, from: url) { [weak self] result in
            switch result {
            case .success(let link):
                self?.fetchItemData(from: link.href) {
                    completion()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteItem(completion: @escaping () -> Void) {
        guard var urlComponents = URLComponents(string: Link.toItem.rawValue) else { return }
        urlComponents.queryItems = [URLQueryItem(name: "path", value: path)]
        guard let url = urlComponents.url else { return }
        NetworkManager.shared.sendRequest(with: Empty.self, to: url, byMethod: .delete) { result in
            switch result {
            case .success(_):
                completion()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func shareItemLink(completion: @escaping (String?) -> Void) {
        guard var urlComponents = URLComponents(string: Link.toShare.rawValue) else { return }
        urlComponents.queryItems = [URLQueryItem(name: "path", value: path)]
        guard let url = urlComponents.url else { return }
        NetworkManager.shared.sendRequest(with: ItemLink.self, to: url, byMethod: .put) { [weak self] result in
            switch result {
            case .success(_):
                self?.fetchItemLink { itemLink in
                    completion(itemLink)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func renameItem(to name: String, completion: @escaping () -> Void) {
        guard var urlComponents = URLComponents(string: Link.toEdit.rawValue) else { return }
        urlComponents.queryItems = [
            URLQueryItem(name: "from", value: path),
            URLQueryItem(name: "path", value: changePath(by: name))
        ]
        guard let url = urlComponents.url else { return }
        NetworkManager.shared.sendRequest(with: ItemLink.self, to: url, byMethod: .post) { result in
            switch result {
            case .success(_):
                completion()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func changePath(by name: String) -> String {
        guard let fullName = path.split(separator: "/").last else { return "" }
        let nameToChange = NSString(string: String(fullName)).deletingPathExtension
        return path.replacingOccurrences(of: nameToChange, with: name)
    }
    
    private func fetchItemData(from url: String, completion: @escaping () -> Void) {
        switch itemType {
        case .image, .pdf:
            NetworkManager.shared.fetchData(from: url) { [weak self] result in
                switch result {
                case .success(let data):
                    self?.itemData = data
                    completion()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case .document:
            guard let url = URL(string: url) else { return }
            request = URLRequest(url: url)
            completion()
        }
    }
    
    private func fetchItemLink(completion: @escaping (String?) -> Void) {
        guard var urlComponents = URLComponents(string: Link.toItem.rawValue) else { return }
        urlComponents.queryItems = [URLQueryItem(name: "path", value: path)]
        guard let url = urlComponents.url else { return }
        NetworkManager.shared.fetch(Item.self, from: url) { result in
            switch result {
            case .success(let item):
                completion(item.public_url)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
