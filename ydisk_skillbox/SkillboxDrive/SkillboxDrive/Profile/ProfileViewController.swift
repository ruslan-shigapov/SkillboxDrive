//
//  ProfileViewController.swift
//  SkillboxDrive
//
//  Created by Руслан Шигапов on 20.05.2023.
//

import UIKit
import ALProgressView

class ProfileViewController: UIViewController {

    @IBOutlet var progressView: UIView!
    @IBOutlet var publishedFilesButton: UIView!
    @IBOutlet var circleViews: [UIView]!
    
    @IBOutlet var capacityLabel: UILabel!
    @IBOutlet var usedMemoryLabel: UILabel!
    @IBOutlet var availableMemoryLabel: UILabel!
    
    private lazy var progressRing = ALProgressRing()
    private var viewModel: ProfileViewModelProtocol! {
        didSet {
            viewModel.fetchDiskInfo { [weak self] in
                self?.capacityLabel.text = self?.viewModel.totalSpaceInfo
                self?.usedMemoryLabel.text = self?.viewModel.usedSpaceInfo
                self?.availableMemoryLabel.text = self?.viewModel.availableSpaceInfo
                self?.progressRing.setProgress(self?.viewModel.progress ?? 0, animated: true)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewModel = ProfileViewModel()
        setupUI()
        setupConstraints()
    }
    
    @IBAction func exitButtonPressed(_ sender: UIBarButtonItem) {
        showLogOutAlert()
    }
        
    private func setupUI() {
        progressView.addSubview(progressRing)
        setupProgressRing()
        publishedFilesButton.layer.cornerRadius = 10
        publishedFilesButton.layer.shadowOpacity = 0.3
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
        let alert = UIAlertController(title: "Profile", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let logOutAction = UIAlertAction(title: "Log Out", style: .destructive) { [unowned self] _ in
            showExitAlert()
        }
        alert.addAction(cancelAction)
        alert.addAction(logOutAction)
        present(alert, animated: true)
    }
    
    private func showExitAlert() {
        let alert = UIAlertController(title: "Exit", message: "Are you sure?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .cancel) { _ in
            
            // Action
            
        }
        let noAction = UIAlertAction(title: "No", style: .destructive)
        alert.addAction(yesAction)
        alert.addAction(noAction)
        present(alert, animated: true)
    }
}
