//
//  UserDefaultsHelper.swift
//  Medbook
//
//  Created by Aswin Gopinathan on 05/04/25.
//

import Foundation

struct UserDefaultsHelper {
    private init() {
        //Empty Init
    }
    
    static let shared = UserDefaultsHelper()
    
    func store(_ value: Any?, key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    func get(for key: String) -> Any? {
        UserDefaults.standard.value(forKey: key)
    }
}
