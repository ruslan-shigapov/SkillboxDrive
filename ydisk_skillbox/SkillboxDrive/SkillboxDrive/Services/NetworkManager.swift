//
//  NetworkManager.swift
//  SkillboxDrive
//
//  Created by Руслан Шигапов on 09.03.2023.
//

import Foundation
import Alamofire

enum Link: String {
    case toRecents = "https://cloud-api.yandex.net/v1/disk/resources/last-uploaded?limit=40&preview_size=25x22"
    case toBrowse = "https://cloud-api.yandex.net/v1/disk/resources?path=/&limit=20&preview_size=25x22"
    case toDetails = "https://cloud-api.yandex.net/v1/disk/resources/download"
    case toEdit = "https://cloud-api.yandex.net/v1/disk/resources/move"
    case toDelete = "https://cloud-api.yandex.net/v1/disk/resources"
}

class NetworkManager {
    
    static let shared = NetworkManager()
        
    private var headers: HTTPHeaders {
        guard let token = UserDefaults.standard.string(forKey: "token") else { return [:] }
        return ["Authorization": "OAuth \(token)"]
    }
        
    private init() {}
    
    func fetch<T: Decodable>(_ type: T.Type,
                             from url: URL,
                             completion: @escaping (Result<T, AFError>) -> Void) {
        AF.request(url, headers: headers) { $0.timeoutInterval = 5 }
            .validate()
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func fetchData(from url: String, completion: @escaping (Result<Data, AFError>) -> Void) {
        AF.request(url, headers: headers)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func sendRequest(to url: URL,
                     byMethod method: HTTPMethod,
                     completion: @escaping (Result<ItemLink, AFError>) -> Void) {
        AF.request(url, method: method, headers: headers)
            .validate()
            .responseDecodable(of: ItemLink.self) { response in
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
