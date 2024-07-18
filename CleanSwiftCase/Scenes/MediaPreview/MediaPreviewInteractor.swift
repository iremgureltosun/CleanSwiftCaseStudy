//
//  Created by Tosun, Irem on 17.07.2024.
//  Copyright (c) 2024 Irem Tosun. All rights reserved.
//

import UIKit

protocol MediaPreviewBusinessLogic {
    func displayImage()
}

protocol MediaPreviewDataStore {
    var selectedImageUrl: URL? { get set }
}

final class MediaPreviewInteractor: MediaPreviewBusinessLogic, MediaPreviewDataStore {
    var selectedImageUrl: URL?
    var presenter: MediaPreviewPresentationLogic?
    var worker: MediaPreviewWorker?

    func displayImage() {
        var response = MediaPreview.ViewData.Response()
        response.selectedImageUrl = selectedImageUrl
        presenter?.present(response: response)
    }
}
