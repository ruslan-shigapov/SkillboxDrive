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
    private var viewModel: OnboardingViewModelProtocol! {
        didSet {
            viewModel.viewModelDidChange = { [unowned self] _ in
                setupUI()
            }
        }
    }
    
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = OnboardingViewModel()
        setupUI()
    }
    
    // MARK: - IB Actions
    @IBAction func nextButtonPressed() {
        viewModel.goToNextPage {
            dismiss(animated: true)
        }
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        imageView.image = viewModel.currentPage.image
        textLabel.text = viewModel.currentPage.description
        pageControl.currentPage = viewModel.currentPage.rawValue
    }
}
