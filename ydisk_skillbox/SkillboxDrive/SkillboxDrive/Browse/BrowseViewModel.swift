//
//  BrowseViewModel.swift
//  SkillboxDrive
//
//  Created by Руслан Шигапов on 30.04.2023.
//

import Foundation

protocol BrowseViewModelProtocol {
    func fetchItems(completion: @escaping (Bool) -> Void)
    func fetchExtraItems(afterRowAt indexPath: IndexPath, completion: @escaping () -> Void)
    func numberOfRows() -> Int
    func getItemCellViewModel(at indexPath: IndexPath) -> ItemCellViewModelProtocol
    func getDetailsViewModel(at indexPath: IndexPath) -> DetailsViewModelProtocol
    func checkItem(from viewModel: DetailsViewModelProtocol, completion: () -> Void)
}

class BrowseViewModel: BrowseViewModelProtocol {
    
    private var items: [Item] = []
    private var offset = 20
    
    func fetchItems(completion: @escaping (Bool) -> Void) {
        NetworkManager.shared.fetch(
            Item.self,
            from: Link.Browse.rawValue
        ) { [weak self] result in
            switch result {
            case .success(let item):
                guard let items = item._embedded?.items else { return }
                self?.items = items
                self?.updateCache()
                completion(true)
            case .failure(let error):
                print(error)
                self?.fetchCache()
                completion(false)
            }
        }
    }
    
    func fetchExtraItems(afterRowAt indexPath: IndexPath, completion: @escaping () -> Void) {
        if items.count == offset, indexPath.row == items.count - 1 {
            NetworkManager.shared.fetch(
                Item.self,
                from: Link.Browse.rawValue + "&offset=\(offset)"
            ) { [weak self] result in
                switch result {
                case .success(let item):
                    self?.offset += 20
                    guard let items = item._embedded?.items else { return }
                    self?.items.append(contentsOf: items)
                    self?.updateCache()
                    completion()
                case .failure(let error):
                    print(error)
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
    
    func checkItem(from viewModel: DetailsViewModelProtocol, completion: () -> Void) {
        if viewModel.preview != nil || viewModel.type == "dir" {
            completion()
        }
    }
    
    private func fetchCache() {
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
