//
// Created by engineering on 29/1/23.
// Copyright (c) 2023 Geniebook Pte. Ltd. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxRelay
import SkeletonView
import Alamofire

// MARK: - LIFECYCLE AND CALLBACK

class ViewController: UIViewController {
    // MARK: Outlets

    // MARK: ViewModel

    // MARK: Private Properties

    // Rx
    private var vmBag = DisposeBag()
    private var classBag = DisposeBag()

    // MARK: Data

    // Credentials

    // MARK: Public Properties

    // MARK: Initialization

    // MARK: Lifecycle

    override func loadView() {
        super.loadView()

        initDesign()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        initViews()
        initEvents()
        initData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let infrastructureRemoteApiRaw = DataSource.Remote.GeniebookJsonAPIJsonRequest(
            apiKey: { "" },
            apiUid: { "" },
            baseUrl: { "https://jsonplaceholder.org/" },
            semaphoreProvider: { DispatchSemaphore(value: 10000)},
            apiQueue: { DispatchQueue.main},
            session: AF,
            requestTimeoutProvider: { 120 }
        )
        let infrastructureRemoteApi = DataSource.Remote.GeniebookJsonAPI(apiService: infrastructureRemoteApiRaw)
        let repository = GenieClassRepositoryImpl(remoteDataSource: infrastructureRemoteApi);

        let vm = Presentation.ListViewModelImpl(genieClassRepository: repository)
        let vc = Presentation.UiKit.ListViewController(nibName: nil, bundle: nil, viewModel: vm)
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(
                alongsideTransition: { [weak self] _ in
                    self
                },
                completion: { [weak self] _ in
                    self
                }
        )
    }

    // MARK: Callback

    // MARK: Public Function

    // MARK: Deinitialization

    deinit {
        classBag = DisposeBag()
    }
}

// MARK: - INITIALIZATION

private extension ViewController {
    // MARK: Init Functions
    func initViews() {
    }

    func initEvents() {
    }

    func initData() {
    }

    // MARK: Views

    // MARK: ViewModel

    func subscribeViewModel() {
    }

    func unsubscribeViewModel() {
    }

    // MARK: Model
}

// MARK: - DELEGATIONS

// MARK: - EXTENSION

// MARK: - STATIC DETACHABLE

// MARK: - TRACKING

// MARK: - DESIGN

private extension ViewController {
    // swiftlint:disable:next function_body_length
    func initDesign() {
        // MARK: View Initialization

        // MARK: View Graph

        // MARK: View Constraints

        // MARK: View Assign
    }
}
