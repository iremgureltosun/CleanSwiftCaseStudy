//
//  CleanSwiftCaseTests.swift
//  CleanSwiftCaseTests
//
//  Created by Tosun, Irem on 17.07.2024.
//

@testable import CleanSwiftCase
import Resolver
import XCTest

final class CleanSwiftCaseTests: XCTestCase {
    var mediaService: iTunesSearchService!

    override func setUp() {
        super.setUp()
        Resolver.registerMockServices()
        mediaService = Resolver.resolve(MockiTunesSearchService.self)
    }

    override func tearDown() {
        Resolver.reset()
        mediaService = nil
        super.tearDown()
    }

    func testExplicitType() async throws {
        // Given
        let expectation = expectation(description: "Awaiting operation")
        var result: MediaResponseModel?

        // When
        do {
            result = try await mediaService.getMediaByExplicitType(with: "m", explicit: .yes)
        } catch {
            if let decodingError = error as? DecodingError {
                switch decodingError {
                case let .typeMismatch(type, context):
                    XCTFail("Type mismatch error: \(type), context: \(context.debugDescription).")
                case let .valueNotFound(type, context):
                    XCTFail("Value not found error: \(type), context: \(context.debugDescription).")
                case let .keyNotFound(key, context):
                    XCTFail("Key not found error: \(key), context: \(context.debugDescription).")
                case let .dataCorrupted(context):
                    XCTFail("Data corrupted error: \(context.debugDescription).")
                @unknown default:
                    XCTFail("Unknown decoding error: \(decodingError.localizedDescription).")
                }
            } else {
                XCTFail("Network error occured: \(error.localizedDescription)")
            }
        }
        // Then
        XCTAssertNotNil(result)
        XCTAssertTrue(result?.resultCount == 20)

        expectation.fulfill()
        await fulfillment(of: [expectation], timeout: 5.0)
    }

    func testLanguageType() async throws {
        // Given
        let expectation = expectation(description: "Awaiting operation")
        var result: MediaResponseModel?

        // When
        do {
            result = try await mediaService.getMediaByLanguage(with: "A", language: .japan)
        } catch {
            if let decodingError = error as? DecodingError {
                switch decodingError {
                case let .typeMismatch(type, context):
                    XCTFail("Type mismatch error: \(type), context: \(context.debugDescription).")
                case let .valueNotFound(type, context):
                    XCTFail("Value not found error: \(type), context: \(context.debugDescription).")
                case let .keyNotFound(key, context):
                    XCTFail("Key not found error: \(key), context: \(context.debugDescription).")
                case let .dataCorrupted(context):
                    XCTFail("Data corrupted error: \(context.debugDescription).")
                @unknown default:
                    XCTFail("Unknown decoding error: \(decodingError.localizedDescription).")
                }
            } else {
                XCTFail("Network error occured: \(error.localizedDescription)")
            }
        }
        // Then
        XCTAssertNotNil(result)
        XCTAssertTrue(result?.resultCount == 20)

        expectation.fulfill()
        await fulfillment(of: [expectation], timeout: 5.0)
    }

    func testVersionType() async throws {
        // Given
        let expectation = expectation(description: "Awaiting operation")
        var result: MediaResponseModel?

        // When
        do {
            result = try await mediaService.getMediaByVersion(with: "y", version: .second)
        } catch {
            if let decodingError = error as? DecodingError {
                switch decodingError {
                case let .typeMismatch(type, context):
                    XCTFail("Type mismatch error: \(type), context: \(context.debugDescription).")
                case let .valueNotFound(type, context):
                    XCTFail("Value not found error: \(type), context: \(context.debugDescription).")
                case let .keyNotFound(key, context):
                    XCTFail("Key not found error: \(key), context: \(context.debugDescription).")
                case let .dataCorrupted(context):
                    XCTFail("Data corrupted error: \(context.debugDescription).")
                @unknown default:
                    XCTFail("Unknown decoding error: \(decodingError.localizedDescription).")
                }
            } else {
                XCTFail("Network error occured: \(error.localizedDescription)")
            }
        }
        // Then
        XCTAssertNotNil(result)
        XCTAssertTrue(result?.resultCount == 20)

        expectation.fulfill()
        await fulfillment(of: [expectation], timeout: 5.0)
    }
}

extension Resolver {
    static func registerMockServices() {
        register { MockiTunesSearchService() }
            .implements(iTunesSearchService.self)
    }
}
