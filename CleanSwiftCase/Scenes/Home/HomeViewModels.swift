//
//  Created by Tosun, Irem on 17.07.2024.
//  Copyright (c) 2024 Irem Tosun. All rights reserved.
//

import UIKit

enum HomeView
{
  // MARK: Use cases
  
  enum ViewData
  {
    struct Request
    {
        var term: String
        var criteria: [any Criterion]
    }
    struct Response
    {
        var mediaResponseModels: [MediaResponseModel] = []
    }
    struct ViewModel
    {
        var displayedItems: [Result] = []
    }
  }
}
