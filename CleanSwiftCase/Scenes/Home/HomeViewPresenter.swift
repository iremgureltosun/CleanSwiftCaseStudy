//
//  Created by Tosun, Irem on 17.07.2024.
//  Copyright (c) 2024 Irem Tosun. All rights reserved.
//

import UIKit

protocol HomeViewPresentationLogic {
    func presentResponse(response: HomeView.ViewData.Response)
}

final class HomeViewPresenter: HomeViewPresentationLogic {
    weak var viewController: HomeViewDisplayLogic?

    // MARK: Display items

    func presentResponse(response: HomeView.ViewData.Response) {
        var viewModel = HomeView.ViewData.ViewModel()
        viewModel.displayedItems = response.mediaResponseModels.flatMap { $0.results ?? [] }
        viewController?.displayItems(viewModel: viewModel)
    }
}
