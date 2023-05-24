//
//  BrowseViewModel.swift
//  SkillboxDrive
//
//  Created by Руслан Шигапов on 30.04.2023.
//

import Foundation

protocol BrowseViewModelProtocol: DetailsViewControllerDelegate {
    var networkIsConnected: Bool { get }
    func fetchItems(completion: @escaping () -> Void)
    func fetchExtraItems(afterRowAt indexPath: IndexPath, completion: @escaping () -> Void)
    func numberOfRows() -> Int
    func getItemCellViewModel(at indexPath: IndexPath) -> ItemCellViewModelProtocol
    func getDetailsViewModel(at indexPath: IndexPath) -> DetailsViewModelProtocol
    func checkTransition(by viewModel: DetailsViewModelProtocol, completion: (Bool) -> Void)
    func checkDirectory(completion: () -> Void)
}

class BrowseViewModel: BrowseViewModelProtocol {
    
    var backButtonWasPressed: (() -> Void)?
    var networkIsConnected = false
    
    private var items: [Item] = []
    private var offset = 20
    private var path = "/"
    
    func fetchItems(completion: @escaping () -> Void) {
        guard var urlComponents = URLComponents(string: Link.toBrowse.rawValue) else { return }
        urlComponents.queryItems = [
            URLQueryItem(name: "path", value: path),
            URLQueryItem(name: "preview_size", value: "25x25")
        ]
        guard let url = urlComponents.url else { return }
        NetworkManager.shared.fetch(Item.self, from: url) { [weak self] result in
            switch result {
            case .success(let item):
                self?.networkIsConnected = true
                self?.items = item._embedded?.items ?? []
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
            guard var urlComponents = URLComponents(string: Link.toBrowse.rawValue) else { return }
            urlComponents.queryItems = [
                URLQueryItem(name: "path", value: path),
                URLQueryItem(name: "preview_size", value: "25x25"),
                URLQueryItem(name: "offset", value: String(offset))
            ]
            guard let url = urlComponents.url else { return }
            NetworkManager.shared.fetch(Item.self, from: url) { [weak self] result in
                switch result {
                case .success(let item):
                    self?.offset += 20
                    self?.items.append(contentsOf: item._embedded?.items ?? [])
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
    
    func getItemCellViewModel(at indexPath: IndexPath) -> ItemCellViewModelProtocol {
        ItemCellViewModel(item: items[indexPath.row])
    }
    
    func getDetailsViewModel(at indexPath: IndexPath) -> DetailsViewModelProtocol {
        DetailsViewModel(item: items[indexPath.row])
    }
    
    func checkTransition(by viewModel: DetailsViewModelProtocol, completion: (Bool) -> Void) {
        if viewModel.preview != nil, networkIsConnected {
            completion(true)
        } else if viewModel.type == "dir", networkIsConnected {
            path += "\(viewModel.name)/"
            completion(false)
        }
    }
    
    func checkDirectory(completion: () -> Void) {
        if items.isEmpty {
            completion()
        }
    }
    
    private func fetchCache() {
        StorageManager.shared.fetchFiles { result in
            switch result {
            case .success(let files):
                let filesFromBrowse = files.filter { $0.relateTo == "Browse" }
                items = Item.getItems(from: filesFromBrowse)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func updateCache() {
        for item in items {
            StorageManager.shared.saveFile(
                item.name,
                item.preview,
                item.created,
                item.type,
                item.size,
                fromList: "Browse"
            )
        }
    }
}
