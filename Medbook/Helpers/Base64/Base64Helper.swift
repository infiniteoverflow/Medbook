//
//  Base64Helper.swift
//  Medbook
//
//  Created by Aswin Gopinathan on 05/04/25.
//

import Foundation

struct Base64Helper {
    func encode(_ value: [String: Any]) -> String? {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: value, options: []) else {
            return nil
        }
        
        return jsonData.base64EncodedString()
    }
    
    func decode(_ value: String) -> [String: Any]? {
        guard let data = Data(base64Encoded: value) else {
            return nil
        }
        
        guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            return nil
        }
        
        return jsonObject
    }
}
