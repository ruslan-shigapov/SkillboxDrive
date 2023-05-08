//
//  BrowseViewModel.swift
//  SkillboxDrive
//
//  Created by Руслан Шигапов on 30.04.2023.
//

import Foundation

protocol BrowseViewModelProtocol {
    func fetchResponse(completion: @escaping (Bool) -> Void)
    func numberOfRows() -> Int
    func getItemCellViewModel(at indexPath: IndexPath) -> ItemCellViewModelProtocol
//    func getDetailsViewModel(at indexPath: IndexPath) -> DetailsViewModelProtocol
}

class BrowseViewModel: BrowseViewModelProtocol {
    
    private var items: [Item] = []
    
    func fetchResponse(completion: @escaping (Bool) -> Void) {
        NetworkManager.shared.fetch(
            Response.self,
            from: Link.BrowseURL.rawValue
        ) { [weak self] result in
            switch result {
            case .success(let response):
                self?.items = response.items
                completion(true)
            case .failure(let error):
                print(error.localizedDescription)
                self?.fetchData()
                completion(false)
            }
        }
    }
    
    func numberOfRows() -> Int {
        items.count
    }
    
    func getItemCellViewModel(at indexPath: IndexPath) -> ItemCellViewModelProtocol {
        ItemCellViewModel(item: items[indexPath.row], fromList: "Browse")
    }
    
    private func fetchData() {
        StorageManager.shared.fetchData { [weak self] result in
            switch result {
            case .success(let files):
                let filesFromBrowse = files.filter { $0.fromList == "Browse" }
                self?.items = Item.getItems(from: filesFromBrowse)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
