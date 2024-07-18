//
//  Created by Tosun, Irem on 17.07.2024.
//  Copyright (c) 2024 Irem Tosun. All rights reserved.
//

import UIKit

@objc protocol HomeViewRoutingLogic {
    func routeToMediaPreview()
}

protocol HomeViewDataPassing {
    var dataStore: HomeViewDataStore? { get }
}

final class HomeViewRouter: NSObject, HomeViewRoutingLogic, HomeViewDataPassing {
    weak var viewController: HomeViewViewController?
    var dataStore: HomeViewDataStore?

    // MARK: - Routing

    func routeToMediaPreview() {
        let destinationVC = MediaPreviewViewController()
        var destinationDS = destinationVC.router!.dataStore!
        passDataToMediaPreview(source: dataStore!, destination: &destinationDS)
        navigateToMediaPreview(source: viewController!, destination: destinationVC)
    }

    // MARK: - Navigation

    func navigateToMediaPreview(source: HomeViewViewController, destination: MediaPreviewViewController) {
        source.navigationController?.pushViewController(destination, animated: true)
    }

    // MARK: - Passing data

    func passDataToMediaPreview(source: HomeViewDataStore, destination: inout MediaPreviewDataStore) {
        destination.selectedImageUrl = source.selectedImageUrl
    }
}
