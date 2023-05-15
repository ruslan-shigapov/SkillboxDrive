//
//  DetailsViewController.swift
//  SkillboxDrive
//
//  Created by Руслан Шигапов on 13.05.2023.
//

import UIKit
import PDFKit

class DetailsViewController: UIViewController {
    
    // MARK: - IB Outlets
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var pdfView: PDFView!
    
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
    
    // MARK: - Private Methods
    private func setupUI() {
        nameLabel.text = viewModel.name
        infoLabel.text = viewModel.created
        viewModel.fetchLink { [unowned self] in
//            imageView.isHidden = false
            guard let itemData = viewModel.itemData else { return }
//            imageView.image = UIImage(data: itemData)
            pdfView.isHidden = false
            guard let document = PDFDocument(data: itemData) else { return }
            pdfView.document = document
            pdfView.autoScales = true
            activityIndicator.stopAnimating()
        }
    }
}
