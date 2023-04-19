//
//  AuthViewController.swift
//  SkillboxDrive
//
//  Created by Руслан Шигапов on 19.04.2023.
//

import UIKit
import WebKit

protocol AuthViewControllerDelegate: AnyObject {
    func handleTokenChanged(token: String)
}

class AuthViewController: UIViewController {
    
    weak var delegate: AuthViewControllerDelegate?
    
    private let webView = WKWebView()
    private let clientID = "c503ad12d73b459f8f68967c64cbd0c6"

    private var request: URLRequest? {
        guard var urlComponents = URLComponents(
            string: "https://oauth.yandex.ru/authorize") else { return nil }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "client_id", value: "\(clientID)")
        ]
        guard let url = urlComponents.url else { return nil }
        return URLRequest(url: url)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        guard let request = request else { return }
        webView.load(request)
        webView.navigationDelegate = self
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension AuthViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping(WKNavigationActionPolicy) -> Void) {
        
        if let url = navigationAction.request.url {
            let targetString = url.absoluteString.replacingOccurrences(of: "#", with: "?")
            guard let components = URLComponents(string: targetString) else { return }

            let token = components.queryItems?.first(where: { $0.name == "access_token" })?.value

            if let token = token {
                print(token)
                delegate?.handleTokenChanged(token: token)
            }

            dismiss(animated: true)
        }
    }
}
