//
//  Resolver.swift
//  CleanSwiftCase
//
//  Created by Tosun, Irem on 17.07.2024.
//

import Resolver

extension Resolver: ResolverRegistering {
    func registerServices() {
        register(iTunesSearchService.self) { iTunesSearchServiceImpl() }.scope(.cached)
    }

    public static func registerAllServices() {
        Resolver.main.registerServices()
    }
}
