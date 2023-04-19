//
//  NetworkManager.swift
//  SkillboxDrive
//
//  Created by Руслан Шигапов on 09.03.2023.
//

import Foundation
import Alamofire

enum Link: String {
    case url = "https://oauth.yandex.ru/authorize?response_type=code&client_id=f50a781a68354ae48cc0a5a33d25eca4"
}

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
//    func fetchAccess(from url: String, completion: @escaping (Result<Response, Error>) -> Void) {
//        AF.request(url)
//            .validate()
//            .responseJSON { dataResponse in
//                switch dataResponse.result {
//                case .success(let value):
//                    let response = Response.init(from: )
//                    completion(.success(response))
//                case .failure(let error):
//                    completion(.failure(error))
//                }
//            }
//    }
}
