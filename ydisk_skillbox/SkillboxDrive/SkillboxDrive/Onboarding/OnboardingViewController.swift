//
//  OnboardingViewController.swift
//  SkillboxDrive
//
//  Created by Руслан Шигапов on 09.03.2023.
//

import UIKit

class OnboardingViewController: UIViewController {
        
    @IBOutlet var textLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var pageControl: UIPageControl!
        
    var currentPage = OnboardingScreen.first
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
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
    
    private func updateUI() {
        pageControl.currentPage = currentPage.rawValue
        textLabel.text = currentPage.definition
        imageView.image = currentPage.image
    }
}
