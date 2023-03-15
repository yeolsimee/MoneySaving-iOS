//
//  NetworkClient.swift
//  moneysave
//
//  Created by Bluewave on 2023/03/15.
//

import Foundation
import Alamofire

class NetworkClient {
    static let session: Session = {
        let configuration = URLSessionConfiguration.af.default
        let apiLogger = APIMonitor()
        return Session(configuration: configuration, eventMonitors: [apiLogger])
    }()
    
    typealias onSuccess<T> = ((T) -> Void)
    typealias onFailure = ((_ error: Error) -> Void)
    
    // MARK: Base Client
    static func request<T>(_ object: T.Type,
                           router: URLRequestConvertible,
                           success: @escaping onSuccess<T>,
                           failure: @escaping onFailure) where T: Decodable {
        session.request(router)
            .validate(statusCode: 200..<500)
            .responseDecodable(of: object) { response in
                switch response.result {
                case .success:
                    guard let decodedData = response.value else { return }
                    success(decodedData)
                case .failure(let err):
                    failure(err)
                }
            }
    }
}
