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
    var viewModel: DetailsViewModelProtocol!

    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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
    
    private func setupUI() {
        nameLabel.text = viewModel.name
        infoLabel.text = viewModel.created
        viewModel.fetchLink { [unowned self] in
            guard let imageData = viewModel.itemData else { return }
            imageView.image = UIImage(data: imageData)
            activityIndicator.stopAnimating()
        }
    }
}
