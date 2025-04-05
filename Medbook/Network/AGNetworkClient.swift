//
//  AGNetworkClient.swift
//  Medbook
//
//  Created by Aswin Gopinathan on 05/04/25.
//

import Foundation

///AG stands for my name Aswin Gopinathan :P
///Making it a singleton so that we can have a shared instance of AGNetworkClient throughout the app
struct AGNetworkClient: AGNetworkClientProtocol {
    private init() {
        //Empty Init
    }
    
    static let shared = AGNetworkClient()
    
    func makeRequest<T: Codable>(urlString: String,
                                 httpMethod: HttpRequestType,
                                 type: T.Type,
                                 completion: @escaping (ApiError?, T?) -> Void) {
        ///If an invalid url is passed, return with an .invalidUrl enum
        guard let url = URL(string: urlString) else {
            completion(.invalidUrl, nil)
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            ///If error occured while making the api call
            //TODO: Handle error codes
            guard error != nil else {
                completion(.somethingWentWrong, nil)
                return
            }
            
            ///If data is nil, or it fails to decode the data instance to the given type
            guard let data,
                  let responseData = try? JSONDecoder().decode(T.self, from: data) else {
                completion(.invalidData, nil)
                return
            }
            
            completion(nil, responseData)
        }
        dataTask.resume()
    }
}

