//
//  DetailsViewController.swift
//  SkillboxDrive
//
//  Created by Руслан Шигапов on 13.05.2023.
//

import UIKit

class DetailsViewController: UIViewController {
    
    // MARK: - IB Outlets
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    // MARK: - Public Properties
    var viewModel: DetailsViewModelProtocol! {
        didSet {
            viewModel.downloadItem { [weak self] in
                guard let imageData = self?.viewModel.itemData else { return }
                self?.imageView.image = UIImage(data: imageData)
                self?.activityIndicator.stopAnimating()
            }
        }
    }

    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = viewModel.name
        infoLabel.text = viewModel.created
    }
    
    // MARK: - IB Actions
    @IBAction func backButtonPressed() {
        dismiss(animated: true)
    }
    
    @IBAction func editButtonPressed() {
        
    }
    
    @IBAction func deleteButtonPressed() {
        
    }
    
    @IBAction func shareButtonPressed() {
        
    }
}
