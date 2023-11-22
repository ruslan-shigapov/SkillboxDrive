//
//  ProfileViewController.swift
//  SkillboxDrive
//
//  Created by Руслан Шигапов on 20.05.2023.
//

import UIKit
import ALProgressView

class ProfileViewController: UIViewController {

    // MARK: - IB Outlets
    @IBOutlet var progressView: UIView!
    @IBOutlet var publishedFilesButton: UIView!
    @IBOutlet var circleViews: [UIView]!
    
    @IBOutlet var capacityLabel: UILabel!
    @IBOutlet var usedMemoryLabel: UILabel!
    @IBOutlet var availableMemoryLabel: UILabel!
    
    // MARK: - Private Properties
    private lazy var progressRing = ALProgressRing()
    private var viewModel: ProfileViewModelProtocol! {
        didSet {
            viewModel.fetchDiskInfo { [weak self] in
                self?.capacityLabel.text = self?.viewModel.totalSpaceInfo
                self?.usedMemoryLabel.text = self?.viewModel.usedSpaceInfo
                self?.availableMemoryLabel.text = self?.viewModel.availableSpaceInfo
                self?.progressRing.setProgress(
                    self?.viewModel.progress ?? 0,
                    animated: true
                )
            }
        }
    }
    
    // MARK: - Override Methods
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewModel = ProfileViewModel()
        setupUI()
        setupConstraints()
    }
    
    // MARK: - IB Actions
    @IBAction func exitButtonPressed(_ sender: UIBarButtonItem) {
        showLogOutAlert()
    }
      
    @IBAction func publishedFilesButtonPressed() {
        performSegue(withIdentifier: "toPublished", sender: nil)
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        progressView.addSubview(progressRing)
        setupProgressRing()
        publishedFilesButton.layer.cornerRadius = 10
        publishedFilesButton.layer.shadowOpacity = 0.2
        publishedFilesButton.layer.shadowColor = UIColor.black.cgColor
        publishedFilesButton.layer.shadowRadius = 12
        circleViews.forEach { $0.layer.cornerRadius = $0.frame.width / 2 }
    }
    
    private func setupConstraints() {
        progressRing.translatesAutoresizingMaskIntoConstraints = false
        progressRing.centerXAnchor.constraint(equalTo: progressView.centerXAnchor).isActive = true
        progressRing.centerYAnchor.constraint(equalTo: progressView.centerYAnchor).isActive = true
        progressRing.widthAnchor.constraint(equalToConstant: 200).isActive = true
        progressRing.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    private func setupProgressRing() {
        progressRing.startColor = circleViews[0].backgroundColor ?? .systemPink
        progressRing.endColor = circleViews[0].backgroundColor ?? .systemPink
        progressRing.grooveColor = circleViews[1].backgroundColor ?? .systemGray
    }
    
    // MARK: - Alert Controllers
    private func showLogOutAlert() {
        let alert = UIAlertController(
            title: Constants.Text.profile,
            message: nil,
            preferredStyle: .actionSheet
        )
        let cancelAction = UIAlertAction(title: Constants.Text.cancel, style: .cancel)
        let logOutAction = UIAlertAction(
            title: Constants.Text.logOut,
            style: .destructive
        ) { [unowned self] _ in
            showExitAlert()
        }
        alert.addAction(cancelAction)
        alert.addAction(logOutAction)
        present(alert, animated: true)
    }
    
    private func showExitAlert() {
        let alert = UIAlertController(
            title: Constants.Text.exit,
            message: Constants.Text.confirmation,
            preferredStyle: .alert
        )
        let yesAction = UIAlertAction(title: Constants.Text.yes, style: .cancel) { _ in
            self.dismiss(animated: true) {
                UserDefaults.standard.removeObject(forKey: "token")
            }
        }
        let noAction = UIAlertAction(title: Constants.Text.no, style: .destructive)
        alert.addAction(yesAction)
        alert.addAction(noAction)
        present(alert, animated: true)
    }
}
