//
//  RecentsViewModel.swift
//  SkillboxDrive
//
//  Created by Руслан Шигапов on 24.04.2023.
//

import Foundation

protocol RecentsViewModelProtocol {
    func fetchItems(completion: @escaping (Bool) -> Void)
    func numberOfRows() -> Int
    func getItemCellViewModel(at indexPath: IndexPath) -> ItemCellViewModelProtocol
    func getDetailsViewModel(at indexPath: IndexPath) -> DetailsViewModelProtocol
}

class RecentsViewModel: RecentsViewModelProtocol {
    
    private var items: [Item] = [] 
    
    func fetchItems(completion: @escaping (Bool) -> Void) {
        NetworkManager.shared.fetch(
            ItemList.self,
            from: Link.Recents.rawValue
        ) { [weak self] result in
            switch result {
            case .success(let itemList):
                self?.items = itemList.items
                self?.updateCache()
                completion(true)
            case .failure(let error):
                print(error)
                self?.fetchData()
                completion(false)
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
    
    private func fetchData() {
        StorageManager.shared.fetchFiles { [unowned self] result in
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
