//
//  RecentsViewModel.swift
//  SkillboxDrive
//
//  Created by Руслан Шигапов on 24.04.2023.
//

import Foundation

protocol RecentsViewModelProtocol {
    func fetchResponse(completion: @escaping (Bool) -> Void)
    func numberOfRows() -> Int
    func getItemCellViewModel(at indexPath: IndexPath) -> ItemCellViewModelProtocol
//    func getDetailsViewModel(at indexPath: IndexPath) -> DetailsViewModelProtocol
}

class RecentsViewModel: RecentsViewModelProtocol {
    
    private var items: [Item] = []
    
    func fetchResponse(completion: @escaping (Bool) -> Void) {
        NetworkManager.shared.fetch(
            Response.self,
            from: Link.RecentsURL.rawValue
        ) { [weak self] result in
            switch result {
            case .success(let response):
                guard let items = response.items else { return }
                self?.items = items
                completion(true)
            case .failure(_):
                self?.fetchData()
                completion(false)
            }
        }
    }
    private func fetchData() {
        StorageManager.shared.fetchData { [weak self] result in
            switch result {
            case .success(let files):
                self?.items = Item.getItems(from: files)
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
}
