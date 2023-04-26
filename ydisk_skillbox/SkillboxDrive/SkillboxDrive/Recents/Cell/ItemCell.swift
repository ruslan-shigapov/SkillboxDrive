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
            if let imageURL = URL(string: viewModel.preview ?? "") {
                iconView.kf.indicatorType = .activity
                iconView.kf.setImage(with: imageURL)
            } else {
                iconView.image = UIImage(named: "Folder")
            }
        }
    }
}
