//
//  BrowseViewModel.swift
//  SkillboxDrive
//
//  Created by Руслан Шигапов on 30.04.2023.
//

import Foundation

protocol BrowseViewModelProtocol {
    func fetchItems(completion: @escaping (Bool) -> Void)
    func fetchExtraItems(completion: @escaping () -> Void)
    func numberOfRows() -> Int
    func getItemCellViewModel(at indexPath: IndexPath) -> ItemCellViewModelProtocol
    func getDetailsViewModel(at indexPath: IndexPath) -> DetailsViewModelProtocol
}

class BrowseViewModel: BrowseViewModelProtocol {
    
    private var items: [Item] = []
    private var offset = 20
    
    func fetchItems(completion: @escaping (Bool) -> Void) {
        NetworkManager.shared.fetchResponse(from: Link.BrowseURL.rawValue) { [weak self] result in
            switch result {
            case .success(let response):
                self?.items = response.items
                self?.saveData()
                completion(true)
            case .failure(let error):
                print(error)
                self?.fetchData()
                completion(false)
            }
        }
    }
    
    func fetchExtraItems(completion: @escaping () -> Void) {
        NetworkManager.shared.fetchResponse(
            from: Link.BrowseURL.rawValue + "&offset=\(offset)"
        ) { [weak self] result in
            switch result {
            case .success(let response):
                self?.offset += 20
                self?.items.append(contentsOf: response.items)
                self?.saveData()
                completion()
            case .failure(let error):
                print(error.localizedDescription)
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
                let filesFromBrowse = files.filter { $0.relateTo == "Browse" }
                items = Item.getItems(from: filesFromBrowse)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func saveData() {
        for item in items {
            StorageManager.shared.saveFile(
                item.name,
                item.created,
                item.size,
                item.preview,
                fromList: "Browse"
            )
        }
    }
}
