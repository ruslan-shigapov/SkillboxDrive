//
//  NetworkManager.swift
//  SkillboxDrive
//
//  Created by Руслан Шигапов on 09.03.2023.
//

import Foundation
import Alamofire

enum Link: String {
    case Recents = "https://cloud-api.yandex.net/v1/disk/resources/last-uploaded?limit=40&preview_size=25x22"
    case Browse = "https://cloud-api.yandex.net/v1/disk/resources?path=/&limit=20&preview_size=25x22"
    case Details = "https://cloud-api.yandex.net/v1/disk/resources/download?path="
}

class NetworkManager {
    
    static let shared = NetworkManager()
        
    private var token: String {
        UserDefaults.standard.string(forKey: "token") ?? ""
    }
        
    private init() {}
    
    func fetch<T: Decodable>(_ type: T.Type, from url: String, completion: @escaping (Result<T, AFError>) -> Void) {
        AF.request(url, headers: ["Authorization": "OAuth \(token)"]
        ) { $0.timeoutInterval = 4 }
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
