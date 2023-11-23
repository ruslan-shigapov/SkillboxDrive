//
//  PublishedItemCell.swift
//  SkillboxDrive
//
//  Created by Руслан Шигапов on 23.05.2023.
//

import UIKit

final class PublishedItemCell: UITableViewCell {
    
    @IBOutlet var iconView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
 
    var delegate: PublishedItemCellDelegate!
    
    var viewModel: PublishedItemCellViewModelProtocol! {
        didSet {
            nameLabel.text = viewModel.name
            infoLabel.text = viewModel.information
            activityIndicator.startAnimating()
            viewModel.fetchImageData { [weak self] imageData in
                self?.iconView.image = UIImage(data: imageData)
                self?.activityIndicator.stopAnimating()
            }
        }
    }
    
    @IBAction func deleteButtonPressed() {
        delegate.deleteButtonWasPressed?(viewModel)
    }
}
