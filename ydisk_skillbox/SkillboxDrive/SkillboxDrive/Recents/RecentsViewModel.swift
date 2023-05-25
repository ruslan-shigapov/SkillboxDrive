//
//  RecentsViewModel.swift
//  SkillboxDrive
//
//  Created by Руслан Шигапов on 24.04.2023.
//

import Foundation

protocol DetailsViewControllerDelegate {
    var backButtonWasPressed: (() -> Void)? { get set }
}

protocol RecentsViewModelProtocol: DetailsViewControllerDelegate {
    var networkIsConnected: Bool { get }
    func fetchItems(completion: @escaping () -> Void)
    func numberOfRows() -> Int
    func getItemCellViewModel(at indexPath: IndexPath) -> ItemCellViewModelProtocol
    func getDetailsViewModel(at indexPath: IndexPath) -> DetailsViewModelProtocol
    func checkTransition(by viewModel: DetailsViewModelProtocol, completion: () -> Void)
}

class RecentsViewModel: RecentsViewModelProtocol {
    
    var backButtonWasPressed: (() -> Void)?
    var networkIsConnected = false

    private var items: [Item] = []
    
    func fetchItems(completion: @escaping () -> Void) {
        guard var urlComponents = URLComponents(string: Link.toRecents.rawValue) else {
            return
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "limit", value: "30"),
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
    
    func numberOfRows() -> Int {
        items.count
    }
    
    func getItemCellViewModel(at indexPath: IndexPath) -> ItemCellViewModelProtocol {
        ItemCellViewModel(item: items[indexPath.row])
    }
    
    func getDetailsViewModel(at indexPath: IndexPath) -> DetailsViewModelProtocol {
        DetailsViewModel(item: items[indexPath.row])
    }
    
    func checkTransition(by viewModel: DetailsViewModelProtocol,
                         completion: () -> Void) {
        if viewModel.preview != nil, networkIsConnected {
            completion()
        }
    }
    
    private func fetchCache() {
        StorageManager.shared.fetchFiles { result in
            switch result {
            case .success(let files):
                let filesFromRecents = files.filter { $0.relateTo == "Recents" }
                items = Item.getItems(from: filesFromRecents)
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
                fromList: "Recents"
            )
        }
    }
}
