//
//  ProfileViewModel.swift
//  SkillboxDrive
//
//  Created by Руслан Шигапов on 20.05.2023.
//

import Foundation

protocol ProfileViewModelProtocol {
    var totalSpaceInfo: String { get }
    var usedSpaceInfo: String { get }
    var availableSpaceInfo: String { get }
    var progress: Float { get }
    func fetchDiskInfo(completion: @escaping () -> Void)
}

final class ProfileViewModel: ProfileViewModelProtocol {
    
    var totalSpaceInfo: String {
        String(convertToGB(totalSpace)) + Constants.Text.totalSpace
    }
    var usedSpaceInfo: String {
        String(convertToGB(usedSpace)) + Constants.Text.usedSpace
    }
    var availableSpaceInfo: String {
        let availableSpace = convertToGB(totalSpace) - convertToGB(usedSpace)
        return String(availableSpace) + Constants.Text.availableSpace
    }
    var progress: Float {
        Float(usedSpace ?? 0) / Float(totalSpace ?? 0)
    }
    
    private var totalSpace: Int?
    private var usedSpace: Int?
        
    func fetchDiskInfo(completion: @escaping () -> Void) {
        guard let url = URL(string: Link.toDiskInfo.rawValue) else { return }
        NetworkManager.shared.fetch(Disk.self, from: url) { [weak self] result in
            switch result {
            case .success(let diskInfo):
                self?.totalSpace = diskInfo.total_space
                self?.usedSpace = diskInfo.used_space
                completion()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func convertToGB(_ bytes: Int?) -> Int {
        (((bytes ?? 0) / 1024) / 1024) / 1024
    }
}
