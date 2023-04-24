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
    private var token: String?

    private var request: URLRequest? {
        guard var urlComponents = URLComponents(
            string: "https://oauth.yandex.ru/authorize") else { return nil }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "client_id", value: "\(DataStore.shared.clientID)")
        ]
        guard let url = urlComponents.url else { return nil }
        return URLRequest(url: url)
    }
    
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let request = request else { return }
        webView.load(request)
        webView.navigationDelegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let tabBarVC = segue.destination as? UITabBarController else { return }
        tabBarVC.selectedIndex = 1
        
        guard let viewControllers = tabBarVC.viewControllers else { return }
        viewControllers.forEach {
            guard let navigationVC = $0 as? UINavigationController else { return }
            if let recentsVC = navigationVC.topViewController as? RecentsViewController {
                recentsVC.token = token
            }
        }
    }
}

// MARK: - WKNavigationDelegate
extension AuthViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if let url = navigationAction.request.url {
            let targetString = url.absoluteString.replacingOccurrences(of: "#", with: "?")
            guard let components = URLComponents(string: targetString) else { return }

            let token = components.queryItems?.first(where: { $0.name == "access_token" })?.value

            if let token = token {
                self.token = token
                performSegue(withIdentifier: "toTabBar", sender: nil)
            }
            decisionHandler(.allow)
        }
    }
}
