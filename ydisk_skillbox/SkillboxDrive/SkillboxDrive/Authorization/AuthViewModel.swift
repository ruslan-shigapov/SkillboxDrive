//
//  AuthViewModel.swift
//  SkillboxDrive
//
//  Created by Руслан Шигапов on 24.04.2023.
//

import Foundation

protocol AuthViewModelProtocol {
    var request: URLRequest? { get }
    func getToken(from url: URL, completion: @escaping() -> Void)
}

class AuthViewModel: AuthViewModelProtocol {
    
    var request: URLRequest? {
        guard var urlComponents = URLComponents(
            string: "https://oauth.yandex.ru/authorize") else { return nil }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "client_id", value: "c503ad12d73b459f8f68967c64cbd0c6")
        ]
        guard let url = urlComponents.url else { return nil }
        return URLRequest(url: url)
    }
    
    func getToken(from url: URL, completion: @escaping () -> Void) {
        let targetString = url.absoluteString.replacingOccurrences(of: "#", with: "?")
        guard let components = URLComponents(string: targetString) else { return }
        let token = components.queryItems?.first(where: { $0.name == "access_token" })?.value
        if let token = token {
            UserDefaults.standard.set(token, forKey: "token")
            completion()
        }
    }
}
