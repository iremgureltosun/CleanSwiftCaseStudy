//
//  MockiTunesSearchService.swift
//  CleanSwiftCase
//
//  Created by Tosun, Irem on 17.07.2024.
//

import Foundation

final class MockiTunesSearchService: iTunesSearchService {
    var mockExplicitResponse: MediaResponseModel?
    var mockLanguageResponse: MediaResponseModel?
    var mockVersionResponse: MediaResponseModel?
    
    func getMediaByExplicitType(with term: String, explicit: Explicit) async throws -> MediaResponseModel {
        let media: MediaResponseModel = try await withCheckedThrowingContinuation { continuation in
            Task {
                let media: MediaResponseModel = MockDataProvider.load(resourceName: "ExplicitMedia")
                continuation.resume(returning: media)
            }
        }
        return media
    }
    
    func getMediaByLanguage(with term: String, language: Language) async throws -> MediaResponseModel {
        let media: MediaResponseModel = try await withCheckedThrowingContinuation { continuation in
            Task {
                let media: MediaResponseModel = MockDataProvider.load(resourceName: "JapaneseMedia")
                continuation.resume(returning: media)
            }
        }
        return media
    }
    
    func getMediaByVersion(with term: String, version: Version) async throws -> MediaResponseModel {
        let media: MediaResponseModel = try await withCheckedThrowingContinuation { continuation in
            Task {
                let media: MediaResponseModel = MockDataProvider.load(resourceName: "VersionMedia")
                continuation.resume(returning: media)
            }
        }
        return media
    }
}
