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
    @IBOutlet var imageViewHeight: NSLayoutConstraint!
    
    // MARK: - Public Properties
    var delegate: DetailsViewControllerDelegate!
    var viewModel: DetailsViewModelProtocol!
    
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDoubleTap()
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
        viewModel.fetchItem { [weak self] in
            switch self?.viewModel.itemType {
            case .image:
                self?.imageView.isHidden = false
                guard let imageData = self?.viewModel.itemData else { return }
                self?.imageView.image = UIImage(data: imageData)
                self?.activityIndicator.stopAnimating()
            case .pdf:
                self?.pdfView.isHidden = false
                guard let pdfData = self?.viewModel.itemData else { return }
                guard let document = PDFDocument(data: pdfData) else { return }
                self?.pdfView.document = document
                self?.pdfView.autoScales = true
                self?.activityIndicator.stopAnimating()
            case .document:
                self?.webView.isHidden = false
                guard let request = self?.viewModel.request else { return }
                self?.webView.load(request)
                self?.webView.navigationDelegate = self
            case .none: return
            }
        }
    }
    
    private func setupDoubleTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(zoomView))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
    }

    @objc private func zoomView() {
        viewModel.imageIsZoomed.toggle()
        imageViewHeight.constant = viewModel.imageIsZoomed
        ? view.safeAreaLayoutGuide.layoutFrame.height
        : 450
    }

    // MARK: - Alert Controllers    
    private func showEditAlert(completion: @escaping (String) -> Void) {
        let title = Constants.Text.rename
        let alert = UIAlertController(
            title: title,
            message: nil,
            preferredStyle: .alert
        )
        alert.setValue(
            NSAttributedString(
                string: title,
                attributes: [.font: UIFont.systemFont(ofSize: 17, weight: .medium)]
            ),
            forKey: "attributedTitle"
        )
        let cancelAction = UIAlertAction(
            title: Constants.Text.cancel,
            style: .cancel
        )
        let doneAction = UIAlertAction(
            title: Constants.Text.done,
            style: .default
        ) { _ in
            guard let newValue = alert.textFields?.first?.text else { return }
            guard !newValue.isEmpty else { return }
            completion(newValue)
        }
        alert.addAction(cancelAction)
        alert.addAction(doneAction)
        alert.addTextField { [weak self] textField in
            textField.placeholder = Constants.Text.placeholder
            textField.text = self?.viewModel.name
        }
        present(alert, animated: true)
    }
    
    private func showDeleteAlert() {
        let title = Constants.Text.deleteAlert
        let alert = UIAlertController(
            title: title,
            message: nil,
            preferredStyle: .actionSheet
        )
        let cancelAction = UIAlertAction(
            title: Constants.Text.cancel,
            style: .cancel
        )
        let deleteAction = UIAlertAction(
            title: Constants.Text.delete,
            style: .destructive
        ) { [unowned self] _ in
            viewModel.deleteItem {
                self.backButtonPressed()
            }
        }
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        present(alert, animated: true)
    }
    
    private func showShareAlert() {
        let alert = UIAlertController(
            title: Constants.Text.share,
            message: nil,
            preferredStyle: .actionSheet
        )
        let cancelAction = UIAlertAction(
            title: Constants.Text.cancel,
            style: .cancel
        )
        let shareFileAction = UIAlertAction(
            title: Constants.Text.withFile,
            style: .default
        ) { [weak self] _ in
            guard let itemData = self?.viewModel.itemData else { return }
            let shareController = UIActivityViewController(
                activityItems: [itemData],
                applicationActivities: nil
            )
            self?.present(shareController, animated: true)
        }
        let shareLinkAction = UIAlertAction(
            title: Constants.Text.withLink,
            style: .default
        ) { [weak self] _ in
            self?.viewModel.shareItemLink { link in
                guard let link else { return }
                let shareController = UIActivityViewController(
                    activityItems: [link],
                    applicationActivities: nil
                )
                self?.present(shareController, animated: true)
            }
        }
        shareFileAction.setValue(UIColor.black, forKey: "titleTextColor")
        shareLinkAction.setValue(UIColor.black, forKey: "titleTextColor")
        alert.addAction(cancelAction)
        switch viewModel.itemType {
        case .image, .pdf:
            alert.addAction(shareFileAction)
            alert.addAction(shareLinkAction)
        case .document:
            alert.addAction(shareLinkAction)
        }
        present(alert, animated: true)
    }
}

// MARK: - WKNavigationDelegate
extension DetailsViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
}

// MARK: - UIScrollViewDelegate
extension DetailsViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}
