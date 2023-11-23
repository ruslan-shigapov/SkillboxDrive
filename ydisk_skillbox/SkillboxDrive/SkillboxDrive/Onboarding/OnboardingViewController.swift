//
//  OnboardingViewController.swift
//  SkillboxDrive
//
//  Created by Руслан Шигапов on 09.03.2023.
//

import UIKit

final class OnboardingViewController: UIViewController {
        
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var textLabel: UILabel!
    @IBOutlet var pageControl: UIPageControl!
        
    private var viewModel: OnboardingViewModelProtocol! {
        didSet {
            viewModel.viewModelDidChange = { [weak self] _ in
                self?.setupUI()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = OnboardingViewModel()
        setupUI()
    }
    
    @IBAction func nextButtonWasPressed() {
        viewModel.goToNextPage {
            dismiss(animated: true)
        }
    }
    
    private func setupUI() {
        imageView.image = viewModel.currentPage.image
        textLabel.text = viewModel.currentPage.description
        pageControl.currentPage = viewModel.currentPage.rawValue
    }
}
