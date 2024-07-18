//
//  iTunesSearchService.swift
//  CleanSwiftCase
//
//  Created by Tosun, Irem on 17.07.2024.
//

import Foundation

protocol iTunesSearchService {
    func getMediaByExplicitType(with term: String, explicit: Explicit) async throws -> MediaResponseModel
    func getMediaByLanguage(with term: String, language: Language) async throws -> MediaResponseModel
    func getMediaByVersion(with term: String, version: Version) async throws -> MediaResponseModel
}

final class iTunesSearchServiceImpl: CoreNetworkService<MediaResponseModel>, iTunesSearchService {
    func getMediaByExplicitType(with term: String, explicit: Explicit) async throws -> MediaResponseModel {
        guard let url = URL(string: iTunesSearchAPI.Endpoint.getExplicitUrl(term: term, explicit: explicit)) else {
            throw HTTPError.invalidRequest
        }

        let urlRequest = try buildURLRequest(url: url)
        return try await callAPI(urlRequest)
    }

    func getMediaByLanguage(with term: String, language: Language) async throws -> MediaResponseModel {
        guard let url = URL(string: iTunesSearchAPI.Endpoint.getLangUrl(term: term, language: language)) else {
            throw HTTPError.invalidRequest
        }

        let urlRequest = try buildURLRequest(url: url)
        return try await callAPI(urlRequest)
    }

    func getMediaByVersion(with term: String, version: Version) async throws -> MediaResponseModel {
        guard let url = URL(string: iTunesSearchAPI.Endpoint.getVersionUrl(term: term, version: version)) else {
            throw HTTPError.invalidRequest
        }

        let urlRequest = try buildURLRequest(url: url)
        return try await callAPI(urlRequest)
    }

    private func buildURLRequest(url: URL) throws -> URLRequest {
        // Building the url request with builder pattern
        let apiRequest = APIRequestBuilderImpl<Data>(url)
            .setMethod(.get)
            .build()

        guard let urlRequest = apiRequest.getURLRequest() else {
            throw HTTPError.invalidRequest
        }

        return urlRequest
    }
}
