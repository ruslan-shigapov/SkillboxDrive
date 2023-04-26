//
//  AuthViewController.swift
//  SkillboxDrive
//
//  Created by Руслан Шигапов on 19.04.2023.
//

import Foundation
import WebKit

class AuthViewController: UIViewController {
    
    // MARK: - IB Outlets
    @IBOutlet var webView: WKWebView!
    
    // MARK: - Private Properties
    private var viewModel: AuthViewModelProtocol!
    
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = AuthViewModel()
        guard let request = viewModel.request else { return }
        webView.load(request)
        webView.navigationDelegate = self
    }
}

// MARK: - WKNavigationDelegate
extension AuthViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if let url = navigationAction.request.url {
            viewModel.getToken(from: url) { [unowned self] in
                if let tabBarController = self.storyboard?.instantiateViewController(
                    withIdentifier: "TabBarController") as? UITabBarController {
                    
                    self.present(tabBarController, animated: true)
                }
            }
            decisionHandler(.allow)
        }
    }
}
