//
//  NetworkManager.swift
//  SkillboxDrive
//
//  Created by Руслан Шигапов on 09.03.2023.
//

import Foundation
import Alamofire

enum Link: String {
    case toRecents = "https://cloud-api.yandex.net/v1/disk/resources/last-uploaded"
    case toBrowse = "https://cloud-api.yandex.net/v1/disk/resources"
    case toDetails = "https://cloud-api.yandex.net/v1/disk/resources/download"
    case toEdit = "https://cloud-api.yandex.net/v1/disk/resources/move"
    case toShare = "https://cloud-api.yandex.net/v1/disk/resources/publish"
    case toDiskInfo = "https://cloud-api.yandex.net/v1/disk/"
    case toPublished = "https://cloud-api.yandex.net/v1/disk/resources/public"
    case toUnpublish = "https://cloud-api.yandex.net/v1/disk/resources/unpublish"
}

class NetworkManager {
    
    static let shared = NetworkManager()
        
    private var headers: HTTPHeaders {
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            return [:]
        }
        return ["Authorization": "OAuth \(token)"]
    }
        
    private init() {}
    
    func fetch<T: Decodable>(_ type: T.Type,
                             from url: URL,
                             completion: @escaping (Result<T, AFError>) -> Void) {
        AF.request(url, headers: headers) { $0.timeoutInterval = 3 }
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
    
    func fetchData(from url: String,
                   completion: @escaping (Result<Data, AFError>) -> Void) {
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
    
    func sendRequest<T: Decodable>(with type: T.Type,
                                   to url: URL,
                                   byMethod method: HTTPMethod,
                                   completion: @escaping (Result<T, AFError>) -> Void) {
        AF.request(url, method: method, headers: headers)
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
}
