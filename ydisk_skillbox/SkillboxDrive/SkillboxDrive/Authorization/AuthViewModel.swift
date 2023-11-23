//
//  AuthViewModel.swift
//  SkillboxDrive
//
//  Created by Руслан Шигапов on 24.04.2023.
//

import Foundation

protocol AuthViewModelProtocol {
    var request: URLRequest? { get }
    func getToken(from url: URL, completion: () -> Void)
}

final class AuthViewModel: AuthViewModelProtocol {
        
    var request: URLRequest? {
        guard var urlComponents = URLComponents(
            string: "https://oauth.yandex.ru/authorize"
        ) else {
            return nil
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(
                name: "client_id",
                value: "893573ffe124462a9749195a40f308e2"
            )
        ]
        guard let url = urlComponents.url else { return nil }
        return URLRequest(url: url)
    }
    
    func getToken(from url: URL, completion: () -> Void) {
        let targetString = url.absoluteString.replacingOccurrences(
            of: "#",
            with: "?"
        )
        let components = URLComponents(string: targetString)
        let token = components?.queryItems?.first(
            where: { $0.name == "access_token" }
        )
        if let token = token?.value {
            UserDefaults.standard.set(token, forKey: "token")
            completion()
        }
    }
}

