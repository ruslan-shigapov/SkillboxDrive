//
//  PublishedViewModel.swift
//  SkillboxDrive
//
//  Created by Руслан Шигапов on 22.05.2023.
//

import Foundation

protocol PublishedItemCellDelegate {
    var deleteButtonWasPressed: ((PublishedItemCellViewModelProtocol) -> Void)? { get set }
}

protocol PublishedViewModelProtocol: PublishedItemCellDelegate {
    var networkIsConnected: Bool { get }
    func fetchItems(completion: @escaping () -> Void)
    func fetchExtraItems(afterRowAt indexPath: IndexPath, completion: @escaping () -> Void)
    func numberOfRows() -> Int
    func getPublishedItemCellViewModel(at indexPath: IndexPath) -> PublishedItemCellViewModelProtocol
    func checkDirectory(completion: () -> Void)
    func deletePublished(_ item: PublishedItemCellViewModelProtocol, completion: @escaping () -> Void)
}

class PublishedViewModel: PublishedViewModelProtocol {
    
    var deleteButtonWasPressed: ((PublishedItemCellViewModelProtocol) -> Void)?
    var networkIsConnected = false

    private var items: [Item] = []
    private var offset = 20

    func fetchItems(completion: @escaping () -> Void) {
        guard var urlComponents = URLComponents(string: Link.toPublished.rawValue) else { return }
        urlComponents.queryItems = [
            URLQueryItem(name: "preview_size", value: "25x25")
        ]
        guard let url = urlComponents.url else { return }
        NetworkManager.shared.fetch(ItemList.self, from: url) { [weak self] result in
            switch result {
            case .success(let itemList):
                self?.networkIsConnected = true
                self?.items = itemList.items
                self?.updateCache()
                completion()
            case .failure(let error):
                self?.networkIsConnected = false
                self?.fetchCache()
                print(error.localizedDescription)
                completion()
            }
        }
    }
    
    func fetchExtraItems(afterRowAt indexPath: IndexPath, completion: @escaping () -> Void) {
        if items.count == offset, indexPath.row == (items.count - 1) {
            guard var urlComponents = URLComponents(string: Link.toPublished.rawValue) else { return }
            urlComponents.queryItems = [
                URLQueryItem(name: "preview_size", value: "25x25"),
                URLQueryItem(name: "offset", value: String(offset))
            ]
            guard let url = urlComponents.url else { return }
            NetworkManager.shared.fetch(ItemList.self, from: url) { [weak self] result in
                switch result {
                case .success(let itemList):
                    self?.offset += 20
                    self?.items.append(contentsOf: itemList.items)
                    self?.updateCache()
                    completion()
                case .failure(let error):
                    self?.networkIsConnected = false
                    print(error.localizedDescription)
                    completion()
                }
            }
        }
    }
    
    func numberOfRows() -> Int {
        items.count
    }
    
    func getPublishedItemCellViewModel(at indexPath: IndexPath) -> PublishedItemCellViewModelProtocol {
        PublishedItemCellViewModel(item: items[indexPath.row])
    }
    
    func checkDirectory(completion: () -> Void) {
        if items.isEmpty {
            completion()
        }
    }
    
    func deletePublished(_ item: PublishedItemCellViewModelProtocol, completion: @escaping () -> Void) {
        guard var urlComponents = URLComponents(string: Link.toUnpublish.rawValue) else { return }
        urlComponents.queryItems = [URLQueryItem(name: "path", value: item.path)]
        guard let url = urlComponents.url else { return }
        NetworkManager.shared.sendRequest(with: ItemLink.self, to: url, byMethod: .put) { result in
            switch result {
            case .success(_):
                completion()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetchCache() {
        StorageManager.shared.fetchFiles { result in
            switch result {
            case .success(let files):
                let filesFromBrowse = files.filter { $0.relateTo == "Published" }
                items = Item.getItems(from: filesFromBrowse)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func updateCache() {
        StorageManager.shared.deleteFiles()
        for item in items {
            StorageManager.shared.saveFile(
                item.name,
                item.preview,
                item.created,
                item.type,
                item.size,
                fromList: "Published"
            )
        }
    }
}
