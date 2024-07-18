//
//  Created by Tosun, Irem on 17.07.2024.
//  Copyright (c) 2024 Irem Tosun. All rights reserved.
//

import UIKit

enum MediaPreview {
    // MARK: Use cases

    enum ViewData {
        struct Request {
        }

        struct Response {
            var selectedImageUrl: URL?
        }

        struct ViewModel {
            var selectedImageUrl: URL?
        }
    }
}
