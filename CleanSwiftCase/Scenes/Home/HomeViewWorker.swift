//
//  Created by Tosun, Irem on 17.07.2024.
//  Copyright (c) 2024 Irem Tosun. All rights reserved.
//

import Resolver
import UIKit

final class HomeViewWorker {
    @Injected var service: iTunesSearchService

    func fetchMedia(with term: String, criteria: [any Criterion]) async throws -> [MediaResponseModel] {
        var responses: [MediaResponseModel] = []
        
        let (stream, continuation) = AsyncStream<Void>.makeStream(bufferingPolicy: .bufferingNewest(3))
        
        for _ in 0..<3 {
            continuation.yield()
        }
        
        await withTaskGroup(of: MediaResponseModel?.self) { group in
            for criterion in criteria {
                group.addTask {
                    var iterator = stream.makeAsyncIterator()
                    
                    await iterator.next()
                    
                    defer { continuation.yield() } 
                    
                    do {
                        if let explicit = criterion as? Explicit {
                            return try await self.service.getMediaByExplicitType(with: term, explicit: explicit)
                        } else if let language = criterion as? Language {
                            return try await self.service.getMediaByLanguage(with: term, language: language)
                        } else if let version = criterion as? Version {
                            return try await self.service.getMediaByVersion(with: term, version: version)
                        }
                    } catch {
                        print("Error fetching media: \(error)")
                    }
                    return nil
                }
            }
            
            for await response in group {
                if let response = response {
                    responses.append(response)
                }
            }
        }
        return responses
    }
}
