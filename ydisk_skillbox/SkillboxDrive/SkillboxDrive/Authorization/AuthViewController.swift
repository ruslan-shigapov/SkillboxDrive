//
//  AuthViewController.swift
//  SkillboxDrive
//
//  Created by Руслан Шигапов on 19.04.2023.
//

import Foundation
import WebKit

class AuthViewController: UIViewController {
    
    @IBOutlet var webView: WKWebView!
    
    private let clientID = "c503ad12d73b459f8f68967c64cbd0c6"
    private var token = ""

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

        guard let request = request else { return }
        webView.load(request)
        webView.navigationDelegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navigationVC = segue.destination as? UINavigationController else { return }
        guard let tabBarVC = navigationVC.topViewController as? TabBarController else { return }
        tabBarVC.token = token
    }
}

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
                performSegue(withIdentifier: "toRecents", sender: nil)
            }
            decisionHandler(.allow)
        }
    }
}
