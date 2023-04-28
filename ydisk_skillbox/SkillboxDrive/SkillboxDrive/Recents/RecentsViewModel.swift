//
//  RecentsViewModel.swift
//  SkillboxDrive
//
//  Created by Руслан Шигапов on 24.04.2023.
//

import Foundation

protocol RecentsViewModelProtocol {
    func fetchResponse(completion: @escaping() -> Void)
    func numberOfRows() -> Int
    func getItemCellViewModel(at indexPath: IndexPath) -> ItemCellViewModelProtocol
//    func getDetailsViewModel(at indexPath: IndexPath) -> DetailsViewModelProtocol
}

class RecentsViewModel: RecentsViewModelProtocol {
    
    private var items: [Item] = []
    
    func fetchResponse(completion: @escaping () -> Void) {
        NetworkManager.shared.fetchData(
            from: Link.url.rawValue,
            with: UserDefaults.standard.string(forKey: "token")
        ) { [unowned self] result in
            switch result {
            case .success(let response):
                self.items = response.items ?? []
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
