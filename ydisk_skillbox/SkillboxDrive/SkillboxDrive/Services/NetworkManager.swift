//
//  NetworkManager.swift
//  SkillboxDrive
//
//  Created by Руслан Шигапов on 09.03.2023.
//

import Foundation
import Alamofire

enum Link: String {
    case url = ""
}

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchToken(from url: String, completion: @escaping (Result<Response, Error>) -> Void) {
        
    }
}
