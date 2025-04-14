//
//  AnyRoutableView.swift
//  Medbook
//
//  Created by Aswin Gopinathan on 12/04/25.
//

import Foundation
import SwiftUI

struct AnyRoutableView: RoutableView {
    let base: any RoutableView
    let equals: (any RoutableView) -> Bool
    
    init<T: RoutableView>(_ base: T) {
        self.base = base
        self.equals = { other in
            guard let otherRV = other as? T else {
                return false
            }
            return base == otherRV
        }
    }
    
    func makeView() -> AnyView {
        self.base.makeView()
    }
    
    func hash(into hasher: inout Hasher) {
        self.base.hash(into: &hasher)
    }
    
    static func == (_ lhs: AnyRoutableView, _ rhs: AnyRoutableView) -> Bool {
        lhs.equals(rhs.base)
    }
}
