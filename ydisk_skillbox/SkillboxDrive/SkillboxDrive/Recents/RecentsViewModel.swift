//
//  RecentsViewModel.swift
//  SkillboxDrive
//
//  Created by Руслан Шигапов on 24.04.2023.
//

import Foundation

protocol RecentsViewModelProtocol {
    var isConnected: Bool { get }
    func fetchItems(completion: @escaping () -> Void)
    func numberOfRows() -> Int
    func getItemCellViewModel(at indexPath: IndexPath) -> ItemCellViewModelProtocol
    func getDetailsViewModel(at indexPath: IndexPath) -> DetailsViewModelProtocol
    func checkItem(from viewModel: DetailsViewModelProtocol, completion: () -> Void)
}

class RecentsViewModel: RecentsViewModelProtocol {
    
    var isConnected = false

    private var items: [Item] = []
    
    func fetchItems(completion: @escaping () -> Void) {
        guard let url = URL(string: Link.Recents.rawValue) else { return }
        NetworkManager.shared.fetch(ItemList.self, from: url) { [unowned self] result in
            switch result {
            case .success(let itemList):
                isConnected = true
                items = itemList.items
                updateCache()
                completion()
            case .failure(let error):
                isConnected = false
                fetchCache()
                print(error)
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
    
    func checkItem(from viewModel: DetailsViewModelProtocol, completion: () -> Void) {
        if viewModel.preview != nil, isConnected == true {
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
