//
//  Created by Tosun, Irem on 17.07.2024.
//  Copyright (c) 2024 Irem Tosun. All rights reserved.
//

import UIKit
import SnapKit

protocol MediaPreviewDisplayLogic: AnyObject {
    func displayImage(viewModel: MediaPreview.ViewData.ViewModel)
}

final class MediaPreviewViewController: UIViewController, MediaPreviewDisplayLogic {
    var interactor: MediaPreviewBusinessLogic?
    var router: (NSObjectProtocol & MediaPreviewRoutingLogic & MediaPreviewDataPassing)?

    // MARK: Object lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private func setupImageUI() {
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
        }
    }

    // MARK: Setup

    private func setup() {
        let viewController = self
        let interactor = MediaPreviewInteractor()
        let presenter = MediaPreviewPresenter()
        let router = MediaPreviewRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupImageUI()
        displayImage()
    }

    func displayImage() {
        interactor?.displayImage()
    }

    func displayImage(viewModel: MediaPreview.ViewData.ViewModel) {
        guard let url = viewModel.selectedImageUrl else { return }
        
        UIImage.image(from: url) { [weak self] image in
            self?.imageView.image = image
        }
    }
}
