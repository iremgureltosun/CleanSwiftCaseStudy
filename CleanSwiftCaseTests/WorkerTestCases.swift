//
//  WorkerTestCases.swift
//  CleanSwiftCaseTests
//
//  Created by Tosun, Irem on 17.07.2024.
//

@testable import CleanSwiftCase
import Resolver
import XCTest

final class HomeViewWorkerTests: XCTestCase {
    var homeViewWorker: HomeViewWorker!
    var mediaService: iTunesSearchService!

    override func setUp() {
        super.setUp()
        Resolver.registerMockServices()

        mediaService = Resolver.resolve(MockiTunesSearchService.self)
        homeViewWorker = HomeViewWorker()
    }

    override func tearDown() {
        Resolver.reset()
        homeViewWorker = nil
        mediaService = nil
        super.tearDown()
    }

    func testFetchMediaWithCriteria() async throws {
        // Given
        let expectation = expectation(description: "Awaiting operation")
        let term = "a"
        let criteria: [any Criterion] = [Explicit.yes, Language.english, Version.first]

        // When
        let responses = try await homeViewWorker.fetchMedia(with: term, criteria: criteria)
        
        // Then
        XCTAssertEqual(responses.count, criteria.count)

        expectation.fulfill()
        await fulfillment(of: [expectation], timeout: 5.0)
    }

    func testMaxThreeConcurrentOperations() async throws {
        // Given
        let expectation = expectation(description: "Awaiting operation")
        expectation.expectedFulfillmentCount = 6

        let term = "testTerm"
        let criteria: [any Criterion] = [
            Explicit.yes,
            Language.english,
            Version.first,
            Explicit.no,
            Language.japan,
            Version.second,
        ]
        
        
        // Semaphore to track concurrent tasks
        let semaphore = DispatchSemaphore(value: 3)
        var maxConcurrentTasks = 0
        var currentConcurrentTasks = 0
        let accessQueue = DispatchQueue(label: "com.yourapp.concurrentTasksQueue")

        // When
        func createTask(for criterion: any Criterion) -> Task<MediaResponseModel?, Error> {
            Task {
                semaphore.wait()

                accessQueue.sync {
                    currentConcurrentTasks += 1
                    maxConcurrentTasks = max(maxConcurrentTasks, currentConcurrentTasks)
                }

                defer {
                    accessQueue.sync {
                        currentConcurrentTasks -= 1
                    }
                    semaphore.signal()
                }

                let result: MediaResponseModel
                do {
                    if let explicit = criterion as? Explicit {
                        result = try await mediaService.getMediaByExplicitType(with: term, explicit: explicit)
                    } else if let language = criterion as? Language {
                        result = try await mediaService.getMediaByLanguage(with: term, language: language)
                    } else if let version = criterion as? Version {
                        result = try await mediaService.getMediaByVersion(with: term, version: version)
                    } else {
                        throw NSError(domain: "UnknownCriterion", code: 1, userInfo: nil)
                    }
                    expectation.fulfill()
                    return result
                } catch {
                    expectation.fulfill()
                    throw error
                }
            }
        }

        // Create and run tasks
        var tasks: [Task<MediaResponseModel?, Error>] = []

        for criterion in criteria {
            tasks.append(createTask(for: criterion))
        }

        // Await completion of tasks
        for task in tasks {
            _ = try await task.value
        }

        // Then
        XCTAssertEqual(maxConcurrentTasks, 3)
        await fulfillment(of: [expectation], timeout: 5.0)
    }
}
