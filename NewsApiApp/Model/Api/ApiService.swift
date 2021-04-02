//
//  ApiService.swift
//  NewsApiApp
//
//  Created by Димас on 31.03.2021.
//

import Foundation
import Alamofire

class ApiService<Entity: Codable> {
    
    public init() {}
    
    func fetchData(forURL url: URL, complition: @escaping (Result<Entity, Error>) -> Void) {
        let dataRequest = AF.request(url)
        dataRequest.responseDecodable(of: Entity.self) { res in
            if let error = res.error {
                complition(.failure(error))
            }
            if let entity = res.value {
                complition(.success(entity))
            }
        }
    }
    
}
