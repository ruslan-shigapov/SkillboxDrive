//
//  AuthViewController.swift
//  SkillboxDrive
//
//  Created by Руслан Шигапов on 19.04.2023.
//

import Foundation
import WebKit

final class AuthViewController: UIViewController {
    
    @IBOutlet var webView: WKWebView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    var delegate: AuthViewControllerDelegate!
    
    private var viewModel: AuthViewModelProtocol!

    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = AuthViewModel()
        setupWebView()
    }
    
    private func setupWebView() {
        webView.navigationDelegate = self
        if let request = viewModel.request {
            webView.load(request)
        }
    }
}

// MARK: - WKNavigation delegate
extension AuthViewController: WKNavigationDelegate {
    
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let url = navigationAction.request.url {
            viewModel.getToken(from: url) {
                dismiss(animated: true) { [weak self] in
                    self?.delegate.tokenWasReceived?()
                }
            }
        }
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
}
