//
//  NetworkConfig.swift
//  CleanSwiftCase
//
//  Created by Tosun, Irem on 18.07.2024.
//

import Foundation

enum NetworkConfig {
    static let workersLimit: Int = 20
    static let criteriaList: [any Criterion] = [Explicit.yes, Explicit.no, Version.first, Version.second, Language.english, Language.japan]
}
