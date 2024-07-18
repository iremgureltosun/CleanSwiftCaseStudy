//
//  iTunesSearchEndpoint.swift
//  CleanSwiftCase
//
//  Created by Tosun, Irem on 17.07.2024.
//

import Foundation

struct iTunesSearchAPI {
    enum Endpoint {
        private static let baseMediaURL: String = "https://itunes.apple.com/search?media=\(MediaTypes.software.rawValue)&limit=\(NetworkConfig.workersLimit)"

        private static func getTerm(value: String) -> String {
            return "\(Self.baseMediaURL)&term=\(value)"
        }

        static func getExplicitUrl(term: String, explicit: Explicit) -> String {
            let url = getTerm(value: term)
            return "\(url)&explicit=\(explicit.rawValue)"
        }
        
        static func getLangUrl(term: String, language: Language) -> String {
            let url = getTerm(value: term)
            return "\(url)&lang=\(language.rawValue)"
        }
        
        static func getVersionUrl(term: String, version: Version) -> String {
            let url = getTerm(value: term)
            return "\(url)&version=\(version.rawValue)"
        }
    }
}
