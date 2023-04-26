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
    private var response: Response?
    func fetchResponse(completion: @escaping () -> Void) {
        NetworkManager.shared.fetchData(
            from: Link.url.rawValue,
            with: DataManager.shared.token
        ) { [unowned self] result in
            switch result {
            case .success(let response):
                self.response = response
                completion()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    func numberOfRows() -> Int {
        response?.items?.count ?? 0
    }
    func getItemCellViewModel(at indexPath: IndexPath) -> ItemCellViewModelProtocol {
        ItemCellViewModel(item: (response?.items?[indexPath.row])!)
    }
}
