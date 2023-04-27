//
//  ItemCell.swift
//  SkillboxDrive
//
//  Created by Руслан Шигапов on 22.04.2023.
//

import UIKit
import Kingfisher

class ItemCell: UITableViewCell {

    // MARK: - IB Outlets
    @IBOutlet var iconView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var infoLabel: UILabel!
    
    // MARK: - Public Properties
    var viewModel: ItemCellViewModelProtocol! {
        didSet {
            nameLabel.text = viewModel.name
            infoLabel.text = viewModel.information
            if let preview = viewModel.preview {
                guard let token = DataManager.shared.token else { return }
                let modifier = AnyModifier { request in
                    var request = request
                    request.setValue("OAuth \(token)", forHTTPHeaderField: "Authorization")
                    return request
                }
                iconView.kf.setImage(
                    with: preview,
                    options: [
                        .requestModifier(modifier)
                    ]
                )
            } else {
                iconView.image = UIImage(named: "Folder")
            }
        }
    }
}
