//
//  AGNetworkClientProtocol.swift
//  Medbook
//
//  Created by Aswin Gopinathan on 05/04/25.
//

///Enum for deciding the http request method
enum HttpRequestType: String {
    case get = "GET"
    case post = "POST"
}

enum ApiError: Error {
    ///When network fails due to an internet issue
    case networkFailure
    ///Invalid url passed to the network client
    case invalidUrl
    ///Something went wrong on the server end
    case somethingWentWrong
    ///Invalid response received from server
    case invalidData
}

///Protocol for defining the network manager
protocol AGNetworkClientProtocol {
    ///urlString: Defines the url to make the network call on
    ///httpMethod: The type of HTTP call
    ///type: Defines the type of the parsed model if the api returns success
    ///completion: Can either return an error object or the typed response model
    func makeRequest<T: Codable>(urlString: String,
                                 httpMethod: HttpRequestType,
                                 type: T.Type,
                                 completion: @escaping (ApiError?, T?) -> Void)
}
