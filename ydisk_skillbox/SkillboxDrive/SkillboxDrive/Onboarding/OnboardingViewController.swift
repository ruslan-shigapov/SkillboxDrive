//
//  OnboardingViewController.swift
//  SkillboxDrive
//
//  Created by Руслан Шигапов on 09.03.2023.
//

import UIKit

class OnboardingViewController: UIViewController {
        
    // MARK: - IB Outlets
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var textLabel: UILabel!
    @IBOutlet var pageControl: UIPageControl!
        
    // MARK: - Private Properties
    private var currentPage = OnboardingScreen.first
    
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    // MARK: - IB Actions
    @IBAction func nextButtonPressed() {
        if currentPage == .first {
            currentPage = .second
            updateUI()
        } else if currentPage == .second {
            currentPage = .third
            updateUI()
        } else {
            UserDefaults.standard.set(true, forKey: "thePresentationWasViewed")
            dismiss(animated: true)
        }
    }
    
    // MARK: - Private Methods
    private func updateUI() {
        imageView.image = currentPage.image
        textLabel.text = currentPage.description
        pageControl.currentPage = currentPage.rawValue
    }
}
