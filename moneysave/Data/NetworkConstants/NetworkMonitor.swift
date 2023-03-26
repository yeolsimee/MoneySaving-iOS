//
//  NetworkMonitor.swift
//  moneysave
//
//  Created by Mingoo on 2023/03/15.
//

import Foundation
import Alamofire

final class APIMonitor: EventMonitor {
    let queue = DispatchQueue(label: "EventLogger")
    
    func requestDidFinish(_ request: Request) {
        print("NETWORK Reqeust LOG")
        print(request.description)
        
        print(
            "URL: " + (request.request?.url?.absoluteString ?? "")  + "\n"
            + "Method: " + (request.request?.httpMethod ?? "") + "\n"
            + "Headers: " + "\(request.request?.allHTTPHeaderFields ?? [:])" + "\n"
        )
        print("Authorization: " + (request.request?.headers["Authorization"] ?? ""))
    }
    
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        print("🛰 NETWORK Response LOG")
        print(
            "URL: " + (request.request?.url?.absoluteString ?? "") + "\n"
            + "Result: " + "\(response.result)" + "\n"
            + "StatusCode: " + "\(response.response?.statusCode ?? 0)" + "\n"
        )
    }
}
