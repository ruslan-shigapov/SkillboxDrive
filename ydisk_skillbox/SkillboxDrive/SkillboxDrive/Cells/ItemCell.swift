//
//  ItemCell.swift
//  SkillboxDrive
//
//  Created by Руслан Шигапов on 07.05.2023.
//

import UIKit

class ItemCell: UITableViewCell {

    // MARK: - IB Outlets
    @IBOutlet var iconView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Public Properties
    var viewModel: ItemCellViewModelProtocol! {
        didSet {
            nameLabel.text = viewModel.name
            infoLabel.text = viewModel.information
            if let _ = viewModel.preview {
                activityIndicator.startAnimating()
                viewModel.fetchImage { [weak self] in
                    guard let imageData = self?.viewModel.imageData else { return }
                    self?.iconView.image = UIImage(data: imageData)
                    self?.activityIndicator.stopAnimating()
                }
            } else {
                iconView.image = UIImage(named: "Folder")
            }
            viewModel.saveData()
        }
    }
}
