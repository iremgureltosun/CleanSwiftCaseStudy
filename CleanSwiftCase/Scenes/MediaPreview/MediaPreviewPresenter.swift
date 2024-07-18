//
//  Created by Tosun, Irem on 17.07.2024.
//  Copyright (c) 2024 Irem Tosun. All rights reserved.
//

import UIKit

protocol MediaPreviewPresentationLogic {
    func present(response: MediaPreview.ViewData.Response)
}

final class MediaPreviewPresenter: MediaPreviewPresentationLogic {
    weak var viewController: MediaPreviewDisplayLogic?

    func present(response: MediaPreview.ViewData.Response) {
        var viewModel = MediaPreview.ViewData.ViewModel()
        viewModel.selectedImageUrl = response.selectedImageUrl
        viewController?.displayImage(viewModel: viewModel)
    }
}
