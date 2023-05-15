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
            viewModel.setupUI { isFile in
                if isFile {
                    accessoryType = .disclosureIndicator
                    infoLabel.text = viewModel.information
                    if viewModel.preview != nil {
                        activityIndicator.startAnimating()
                        viewModel.fetchImage { [unowned self] in
                            guard let imageData = viewModel.imageData else { return }
                            iconView.image = UIImage(data: imageData)
                            activityIndicator.stopAnimating()
                        }
                    } else {
                        accessoryType = .none
                        iconView.image = UIImage(systemName: "doc")
                        iconView.tintColor = .black
                    }
                } else {
                    accessoryType = .disclosureIndicator
                    infoLabel.text = viewModel.created
                    iconView.image = UIImage(named: "Folder")
                }
            }
        }
    }
}
