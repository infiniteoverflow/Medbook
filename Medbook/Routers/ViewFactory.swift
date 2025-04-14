//
//  ViewFactory.swift
//  Medbook
//
//  Created by Aswin Gopinathan on 12/04/25.
//

import Foundation
import SwiftUI

typealias RoutableView = ViewFactory & Hashable

protocol ViewFactory {
    func makeView() -> AnyView
}
