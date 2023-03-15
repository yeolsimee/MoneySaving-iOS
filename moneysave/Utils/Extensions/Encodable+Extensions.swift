//
//  Encodable+Extensions.swift
//  moneysave
//
//  Created by Bluewave on 2023/03/15.
//

import Foundation

extension Encodable {
    var toDictionary: [String: Any] {
        guard let object = try? JSONEncoder().encode(self) else {
            print("toDictionary object guard let error")
            return ["" : ""]
        }
        
        guard var dictionary = try? JSONSerialization.jsonObject(with: object, options: []) as? [String:Any] else {
            print("toDictionary dictionary guard let error")
            return ["" : ""]
        }
        
        return dictionary
    }
}
