//
//  PageViewController.swift
//  SkillboxDrive
//
//  Created by Руслан Шигапов on 17.03.2023.
//

import UIKit

protocol PageViewControllerDelegate {
    func showViewControllerAtIndex(_ index: Int) -> OnboardingViewController?
}

class PageViewController: UIPageViewController, PageViewControllerDelegate {
    
    let presentScreenContent = [
        "Теперь все ваши документы в одном месте",
        "Доступ к файлам без интернета",
        "Делитесь вашими файлами с другими"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        if let contentViewController = showViewControllerAtIndex(0) {
            setViewControllers([contentViewController], direction: .forward, animated: true)
        }
    }
    
    func showViewControllerAtIndex(_ index: Int) -> OnboardingViewController? {
        guard index >= 0 else { return nil }
        guard index < presentScreenContent.count else { return nil }
        guard let contentViewController = storyboard?.instantiateViewController(
            withIdentifier: "OnboardingViewController"
        ) as? OnboardingViewController else { return nil }
        
        contentViewController.delegate = self
        
        contentViewController.currentPage = index
        contentViewController.numberOfPages = presentScreenContent.count
        contentViewController.presentText = presentScreenContent[index]
        contentViewController.image = UIImage(named: "Picture \(index)")
        
        return contentViewController
    }
}
