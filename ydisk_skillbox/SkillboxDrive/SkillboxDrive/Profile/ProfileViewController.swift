//
//  ProfileViewController.swift
//  SkillboxDrive
//
//  Created by Руслан Шигапов on 20.05.2023.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet var publishedFilesButton: UIView!
    @IBOutlet var circleViews: [UIView]!
    
    @IBOutlet var usedMemoryLabel: UILabel!
    @IBOutlet var availableMemoryLabel: UILabel!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupViews()
    }
    
    private func setupViews() {
        publishedFilesButton.layer.cornerRadius = 10
        publishedFilesButton.layer.shadowOpacity = 0.3
        publishedFilesButton.layer.shadowColor = UIColor.black.cgColor
        publishedFilesButton.layer.shadowRadius = 12
        circleViews.forEach { $0.layer.cornerRadius = $0.frame.width / 2 }
    }
    
    @IBAction func logOutButton(_ sender: UIBarButtonItem) {
        
    }
}
