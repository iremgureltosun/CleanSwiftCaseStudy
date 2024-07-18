//
//  Created by Tosun, Irem on 17.07.2024.
//  Copyright (c) 2024 Irem Tosun. All rights reserved.
//

import UIKit
import SnapKit

protocol HomeViewDisplayLogic: AnyObject {
    func displayItems(viewModel: HomeView.ViewData.ViewModel)
}

final class HomeViewViewController: UIViewController, HomeViewDisplayLogic, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var interactor: HomeViewBusinessLogic?
    var router: (NSObjectProtocol & HomeViewRoutingLogic & HomeViewDataPassing)?

    // MARK: Object lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: Setup Clean Swift architecture

    private func setup() {
        let viewController = self
        let interactor = HomeViewInteractor()
        let presenter = HomeViewPresenter()
        let router = HomeViewRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    // MARK: Routing

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }

    // MARK: UI Elements

    private let termTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = LabelConstants.searchPlaceholderText
        return textField
    }()

    private let button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(LabelConstants.downloadText, for: .normal)
        button.addTarget(self, action: #selector(fetchItems), for: .touchUpInside)
        return button
    }()

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .gray
        return activityIndicator
    }()

    private var screenshotUrls: [String] = []

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }

    @objc private func fetchItems() {
        guard let term = termTextField.text, !term.isEmpty else { return }
        startLoading()
        // You can add as many criteria as you wish, 3 of them will be processed concurrently.
        let request = HomeView.ViewData.Request(term: term, criteria: NetworkConfig.criteriaList)
        Task {
            try await interactor?.fetchMedia(request: request)
            stopLoading()
        }
    }

    func displayItems(viewModel: HomeView.ViewData.ViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.screenshotUrls = viewModel.displayedItems.flatMap { $0.screenshotUrls }
            self?.collectionView.reloadData()
        }
    }

    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(view)
        }
    }

    private func startLoading() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.startAnimating()
            self?.view.isUserInteractionEnabled = false
        }
    }

    private func stopLoading() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.stopAnimating()
            self?.view.isUserInteractionEnabled = true
        }
    }

    private func setupUI() {
        view.addSubview(termTextField)
        view.addSubview(button)

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.cellIdentifier)
        view.addSubview(collectionView)

        termTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.trailing.equalTo(view).inset(20)
        }

        button.snp.makeConstraints { make in
            make.top.equalTo(termTextField.snp.bottom).offset(20)
            make.centerX.equalTo(view)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(button.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalTo(view)
        }

        setupActivityIndicator()
    }

    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return screenshotUrls.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.cellIdentifier, for: indexPath) as! CollectionViewCell
        cell.contentView.backgroundColor = .clear

        if let imageUrl = URL(string: screenshotUrls[indexPath.item]) {
            // Load the image asynchronously
            UIImage.image(from: imageUrl) { [weak cell] image in
                cell?.imageView.image = image
            }
        }
        return cell
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfColumns: CGFloat = 4
        let spacing: CGFloat = 10
        let totalSpacing = (numberOfColumns - 1) * spacing
        let itemWidth = (collectionView.bounds.width - totalSpacing) / numberOfColumns
        return CGSize(width: itemWidth, height: itemWidth)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let imageUrl = URL(string: screenshotUrls[indexPath.item]) {
            interactor?.setSelectedImageUrl(imageUrl)
            router?.routeToMediaPreview()
        }
    }
}
