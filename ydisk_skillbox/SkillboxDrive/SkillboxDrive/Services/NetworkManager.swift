//
//  NetworkManager.swift
//  SkillboxDrive
//
//  Created by Руслан Шигапов on 09.03.2023.
//

import Foundation
import Alamofire

enum Link: String {
    case RecentsURL = "https://cloud-api.yandex.net/v1/disk/resources/last-uploaded?preview_size=25x22"
    case BrowseURL = "https://cloud-api.yandex.net/v1/disk/resources/files?preview_size=25x22"
    case DetailsURL = ""
}

class NetworkManager {
    static let shared = NetworkManager()
        
    private init() {}
    
    func fetch<T: Decodable>(_ type: T.Type, from url: String, completion: @escaping (Result<T, AFError>) -> Void)  {
        guard let token = UserDefaults.standard.string(forKey: "token") else { return }
        AF.request(url, headers: ["Authorization": "OAuth \(token)"]) { $0.timeoutInterval = 3 }
            .validate()
            .responseDecodable(of: T.self) { dataResponse in
                switch dataResponse.result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func fetchData(from url: String, completion: @escaping (Result<Data, AFError>) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "token") else { return }
        AF.request(url, headers: ["Authorization": "OAuth \(token)"])
            .validate()
            .responseData { dataResponse in
                switch dataResponse.result {
                case .success(let imageData):
                    completion(.success(imageData))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
