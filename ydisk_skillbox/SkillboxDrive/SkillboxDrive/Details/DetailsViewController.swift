//
//  DetailsViewController.swift
//  SkillboxDrive
//
//  Created by Руслан Шигапов on 13.05.2023.
//

import UIKit
import PDFKit
import WebKit

class DetailsViewController: UIViewController {
    
    // MARK: - IB Outlets
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var pdfView: PDFView!
    @IBOutlet var webView: WKWebView!
    
    // MARK: - Public Properties
    var delegate: DetailsViewControllerDelegate!
    var viewModel: DetailsViewModelProtocol!
    
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - IB Actions
    @IBAction func backButtonPressed() {
        dismiss(animated: true) { [weak self] in
            self?.delegate.backButtonWasPressed?()
        }
    }
    
    @IBAction func editButtonPressed() {
        showEditAlert { [weak self] name in
            self?.viewModel.renameItem(to: name) {
                self?.nameLabel.text = name
            }
        }
    }
    
    @IBAction func deleteButtonPressed() {
        showDeleteAlert()
    }
    
    @IBAction func shareButtonPressed() {
        showShareAlert()
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        nameLabel.text = viewModel.name
        infoLabel.text = viewModel.created
        viewModel.fetchItem { [unowned self] in
            switch viewModel.itemType {
            case .image:
                imageView.isHidden = false
                guard let imageData = viewModel.itemData else { return }
                imageView.image = UIImage(data: imageData)
                activityIndicator.stopAnimating()
            case .pdf:
                pdfView.isHidden = false
                guard let pdfData = viewModel.itemData else { return }
                guard let document = PDFDocument(data: pdfData) else { return }
                pdfView.document = document
                pdfView.autoScales = true
                activityIndicator.stopAnimating()
            case .document:
                webView.isHidden = false
                guard let request = viewModel.request else { return }
                webView.load(request)
                webView.navigationDelegate = self
            }
        }
    }
}

// MARK: - Alert Controllers
extension DetailsViewController {
    
    private func showEditAlert(completion: @escaping (String) -> Void) {
        let alert = UIAlertController(title: "Rename", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let doneAction = UIAlertAction(title: "Done", style: .default) { _ in
            guard let newValue = alert.textFields?.first?.text else { return }
            guard !newValue.isEmpty else { return }
            completion(newValue)
        }
        alert.addAction(cancelAction)
        alert.addAction(doneAction)
        alert.addTextField { [unowned self] textField in
            textField.placeholder = "Name"
            textField.text = viewModel.name
        }
        present(alert, animated: true)
    }
    
    private func showDeleteAlert() {
        let title = "This file will be moved to the trash"
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [unowned self] _ in
            viewModel.deleteItem {
                // dismiss
            }
        }
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        present(alert, animated: true)
    }
    
    private func showShareAlert() {
        let alert = UIAlertController(title: "Share this", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let shareFileAction = UIAlertAction(title: "File", style: .default) { _ in
            // Action
        }
        let shareLinkAction = UIAlertAction(title: "Link", style: .default) { _ in
            // Action
        }
        // Buttons color ?
        alert.addAction(cancelAction)
        alert.addAction(shareFileAction)
        alert.addAction(shareLinkAction)
        present(alert, animated: true)
    }
}

// MARK: - WKNavigationDelegate
extension DetailsViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
}

