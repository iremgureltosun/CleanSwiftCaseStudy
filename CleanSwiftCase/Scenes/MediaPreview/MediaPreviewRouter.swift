//
//  Created by Tosun, Irem on 17.07.2024.
//  Copyright (c) 2024 Irem Tosun. All rights reserved.
//

import UIKit

@objc protocol MediaPreviewRoutingLogic
{

}

protocol MediaPreviewDataPassing
{
  var dataStore: MediaPreviewDataStore? { get }
}

final class MediaPreviewRouter: NSObject, MediaPreviewRoutingLogic, MediaPreviewDataPassing
{
  weak var viewController: MediaPreviewViewController?
  var dataStore: MediaPreviewDataStore?
}
