//
//  PublishedItemCell.swift
//  SkillboxDrive
//
//  Created by Руслан Шигапов on 23.05.2023.
//

import UIKit

class PublishedItemCell: UITableViewCell {
    
    // MARK: - IB Outlets
    @IBOutlet var iconView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
 
    // MARK: - Public Properties
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
    
    // MARK: - IB Actions
    @IBAction func deleteButtonPressed() {
        delegate.deleteButtonWasPressed?(viewModel)
    }
}
