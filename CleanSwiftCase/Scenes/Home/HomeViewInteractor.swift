//
//  Created by Tosun, Irem on 17.07.2024.
//  Copyright (c) 2024 Irem Tosun. All rights reserved.
//

import UIKit

protocol HomeViewBusinessLogic {
    func setSelectedImageUrl(_ url: URL?)
    func fetchMedia(request: HomeView.ViewData.Request) async throws
}

protocol HomeViewDataStore {
    var selectedImageUrl: URL? { get set }
}

final class HomeViewInteractor: HomeViewBusinessLogic, HomeViewDataStore {
    var presenter: HomeViewPresentationLogic?
    var worker: HomeViewWorker?
    var selectedImageUrl: URL?

    func setSelectedImageUrl(_ url: URL?) {
        selectedImageUrl = url
    }

    func fetchMedia(request: HomeView.ViewData.Request) async throws {
        worker = HomeViewWorker()
        let mediaResponseModels = try await worker?.fetchMedia(with: request.term, criteria: request.criteria)

        let response = HomeView.ViewData.Response(mediaResponseModels: mediaResponseModels ?? [])
        presenter?.presentResponse(response: response)
    }
}
