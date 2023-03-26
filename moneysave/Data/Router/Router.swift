//
//  Router.swift
//  moneysave
//
//  Created by Mingoo on 2023/03/15.
//

import UIKit
import Alamofire

enum Router: URLRequestConvertible {
    // MARK: - Cases
    case login(dto: LoginRequestDTO)
    case signUp(dto: SignUpRequestDTO)
    
    // MARK: - Method
    var method: HTTPMethod {
        switch self {
        default:
            return .post
        }
    }
    
    // MARK: - Headers
    var headers: HTTPHeaders {
        switch self {
        default:
            return ["Content-Type" : "application/json"]
        }
    }
    
    // MARK: - Paths
    var path: String {
        switch self {
        case .login:
            return "/api/v1/signin"
        case .signUp:
            return "/api/v1/signup"
        }
    }
    
    // MARK: - Parameters
    var parameters: Parameters? {
        switch self {
        case .login(let dto):
            return dto.toDictionary
            
        case .signUp(let dto):
            return dto.toDictionary
        }
    }
    
    // MARK: - Encoding
    var encoding: ParameterEncoding {
        switch self {
        default:
            return URLEncoding.httpBody
        }
    }
    
    // MARK: - URL Request
    func asURLRequest() throws -> URLRequest {
        let url = NetworkConstatns.baseURL.appendingPathExtension(path)
        var urlRequest = URLRequest(url: url)
        
        // HTTP Method
        urlRequest.method = method
        
        urlRequest.headers = headers
        
        if let parameters = parameters {
            return try encoding.encode(urlRequest, with: parameters)
        }
        
        return urlRequest
    }
}
