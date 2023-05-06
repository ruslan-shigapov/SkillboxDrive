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
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Public Properties
    var delegate: AuthViewControllerDelegate!
    
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
            viewModel.getToken(from: url) { [weak self] in
                self?.dismiss(animated: true) {
                    self?.delegate.tokenWasReceived?()
                }
            }
        }
        activityIndicator.stopAnimating()
        decisionHandler(.allow)
    }
}
