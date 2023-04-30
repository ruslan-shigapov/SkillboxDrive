//
//  BrowseViewModel.swift
//  SkillboxDrive
//
//  Created by Руслан Шигапов on 30.04.2023.
//

import Foundation

protocol BrowseViewModelProtocol {
    func fetchResponse(completion: @escaping() -> Void)
    func numberOfRows() -> Int
    func getItemCellViewModel(at indexPath: IndexPath) -> ItemCellViewModelProtocol
//    func getDetailsViewModel(at indexPath: IndexPath) -> DetailsViewModelProtocol
}

class BrowseViewModel: BrowseViewModelProtocol {
    
    private var items: [Item] = []
    
    func fetchResponse(completion: @escaping() -> Void) {
        NetworkManager.shared.fetch(
            Response.self,
            from: Link.BrowseURL.rawValue
        ) { [unowned self] result in
            switch result {
            case .success(let response):
                self.items = response.items
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
}
