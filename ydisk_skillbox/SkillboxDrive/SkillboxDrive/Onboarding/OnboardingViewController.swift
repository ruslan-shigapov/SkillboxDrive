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
    
    var delegate: PageViewControllerDelegate!
    
    var currentPage = 0 
    var numberOfPages = 0
    var image: UIImage?
    var presentText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageControl.currentPage = currentPage
        pageControl.numberOfPages = numberOfPages
        
        textLabel.text = presentText
        imageView.image = image
    }
    
    @IBAction func nextButtonPressed() {
        currentPage += 1
    }
}
