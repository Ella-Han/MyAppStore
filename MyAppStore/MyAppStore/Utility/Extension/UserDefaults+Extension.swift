//
//  UserDefaults+Extension.swift
//  MyAppStore
//
//  Created by 한아름 on 2021/03/24.
//

import Foundation
import Defaults

extension Defaults.Keys {
    static let recentSearchKeywords = Key<[String]>("recentSearchKeywords", default: [])
}
