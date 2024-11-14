//
//  Created by engineering on 23/8/24.
//

import Foundation
import UIKit
import SnapKit
import XLPagerTabStrip
import RxSwift
import RxRelay
import CRRefresh
import LifetimeTracker
import SwiftEventBus

// MARK: - LIFECYCLE AND CALLBACK

extension Presentation.UiKit {
    class ListViewController: V1UIViewController {
        // MARK: Outlets
        internal var vwContainer: UIView?
        internal var vwContentContainer: UIView?
        internal var cvContent: UICollectionView?
        internal var vwEmptyState: UIView?

        // MARK: ViewModel

        private let viewModel: ListViewModel

        // MARK: Service

        // @formatter:off
        // @formatter:on

        // MARK: Private Properties

        private var isInit = true

        private var shouldFetchContent = true
        private let fetchContentLock = NSLock()

        // Rx
        private var classBag = DisposeBag()
        private var vmBag = DisposeBag()

        // CollectionView

        // Credential

        // Scroll

        // MARK: Data

        private var contents = [Domain.PostEntity]()

        private var contentsSizeCache: [String: CGSize] = [:]
        private var calculateCellSizeLock = NSLock()

        // Vc Transition
        private var isVcTransitionInProgress = false

        private var isEligibleToShowEmptyState = false

        // MARK: Public Properties

        // MARK: Initialization
        init(
            nibName nibNameOrNil: String?,
            bundle nibBundleOrNil: Bundle?,
            viewModel: ListViewModel
        ) {
            self.viewModel = viewModel
            super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

#if DEBUG
            trackLifetime()
#endif
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        // MARK: Lifecycle

        override func loadView() {
            LocalizationHelper.initializeIfNotExist()
            super.loadView()

            initDesign()
        }

        override func viewDidLoad() {
            LocalizationHelper.initializeIfNotExist()
            super.viewDidLoad()

            initViews()
            initEvents()
            initData()
        }

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)

            onViewWillAppear(animated)
        }

        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)

            onViewDidAppear(animated)
        }

        override func viewWillDisappear(_ animated: Bool) {
            onViewWillDisappear(animated)

            super.viewWillDisappear(animated)
        }

        override func viewDidDisappear(_ animated: Bool) {
            onViewDidDisappear(animated)

            super.viewDidDisappear(animated)
        }

        override func viewWillLayoutSubviews() {
            super.viewWillLayoutSubviews()

            onViewWillLayoutSubviews()
        }

        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()

            onViewDidLayoutSubviews()
        }

        override open var preferredStatusBarStyle: UIStatusBarStyle {
            super.preferredStatusBarStyle
        }

        // MARK: Override Function

        override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
            isVcTransitionInProgress = true
            super.viewWillTransition(to: size, with: coordinator)

            coordinator.animate(
                alongsideTransition: { [weak self] _ in
                    self
                },
                completion: { [weak self] _ in
                    self?.isVcTransitionInProgress = false
                    self?.refreshScheduleCellCache()
                    self?.calculateCellDimension()
                    self?.cvContent?.layoutIfNeeded()
                }
            )
        }

        override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
            .allButUpsideDown
        }

        override var shouldAutorotate: Bool {
            true
        }

        // MARK: Callback

        private func onViewWillAppear(_ animated: Bool) {
            subscribeViewModel()

            viewModel.reloadCredential()
        }

        private func onViewDidAppear(_ animated: Bool) {
            calculateCellDimension()
            cvContent?.layoutIfNeeded()

            guard isInit else {
                return
            }
            isInit = false

            fetchContentIfEligible()
        }

        private func onViewWillDisappear(_ animated: Bool) {
            unsubscribeViewModel()
        }

        private func onViewDidDisappear(_ animated: Bool) {
        }

        private func onViewWillLayoutSubviews() {
            calculateCellDimension()
        }

        private func onViewDidLayoutSubviews() {
        }

        private func reloadViewController() {
            guard viewIfLoaded?.window != nil else {
                return
            }
            onViewWillDisappear(false)
            onViewDidDisappear(false)

            onViewWillAppear(false)
            onViewWillLayoutSubviews()
            onViewDidLayoutSubviews()
            onViewDidAppear(false)
        }

        private func onTapContent(_ content: Domain.PostEntity) {
            goToDetailPage(content: content)
        }

        // MARK: Public Function

        // MARK: Deinitialization

        deinit {
            classBag = DisposeBag()
            unsubscribeViewModel()
            viewModel.cleanup()
            unregisterEventBus()
        }
    }
}

// MARK: - PRIVATE FUNCTIONS

private extension Presentation.UiKit.ListViewController {
    // MARK: Init Functions
    func initViews() {
        view.backgroundColor = .white
        view.tintColor = .orange

        // Nav Bar
        navigationItem.title = "List"

        // Collection
        setupContentCollectionView()

        // Refresh view state
        refreshEmptyStateVisibility()
    }

    func initEvents() {
        unregisterEventBus()
        registerEventBus()
    }

    func initData() {
        viewModel.reloadCredential()
        // TODO: TEST levelTopicViewModel.reloadCredential()
    }

    // MARK: Views

    // Navigation

    // Collection View

    func setupContentCollectionView() {
        cvContent?.register(
            Presentation.UiKit.ListCollectionCell.self,
            forCellWithReuseIdentifier: Presentation.UiKit.ListCollectionCell.reuseIdentifier
        )
        cvContent?.delegate = self
        cvContent?.dataSource = self
        cvContent?.isPagingEnabled = false
        cvContent?.contentInset = UIEdgeInsets(vertical: 16, horizontal: 0)
        cvContent?.showsHorizontalScrollIndicator = false
        cvContent?.showsVerticalScrollIndicator = false
        cvContent?.alwaysBounceVertical = true

        if let layout = cvContent?.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 16
            layout.minimumInteritemSpacing = 16
            layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
        }
        calculateCellDimension()
    }

    func calculateCellDimension() {
        if let layout = cvContent?.collectionViewLayout as? UICollectionViewFlowLayout {
            let containerWidth = cvContent?.frame.size.width ?? view.frame.width
            guard containerWidth > .zero else {
                return
            }
            let columnCount = 1
            let blankSpace = layout.sectionInset.left +
            layout.sectionInset.right +
            (CGFloat(columnCount - 1) * layout.minimumInteritemSpacing)
            let cellWidth: CGFloat = (containerWidth - blankSpace) / CGFloat(columnCount)

            layout.itemSize.width = cellWidth
            layout.itemSize.height = UIDevice.current.userInterfaceIdiom == .pad ? 160 : 120
        }
        invalidateCollectionView()
        cvContent?.setNeedsUpdateConstraints()
        cvContent?.setNeedsLayout()
    }

    func invalidateCollectionView() {
        cvContent?.collectionViewLayout.invalidateLayout()
    }

    // Collection Empty State

    func refreshEmptyStateVisibility(forceToHide: Bool = false) {
        let shouldHidden = forceToHide || !contents.isEmpty || !isEligibleToShowEmptyState
        if shouldHidden {
            vwEmptyState?.isHidden = true
        } else {
            vwEmptyState?.isHidden = false
        }
    }

    // Loading

    func showListLoading() {
        guard contents.isEmpty else {
            return
        }
        view.showLoadingRocket(delayAnimation: false)
    }

    func hideListLoading() {
        view.hideLoadingRocket()
    }

    // Error

    func handleError(_ error: Error, onComplete: @escaping () -> Void) {
        UiKitErrorHandlerHelper.defaultDialogErrorHandler(
            self,
            withTitle: "list".localized,
            error: error,
            onComplete: onComplete
        )
    }

    // MARK: ViewModel

    // swiftlint:disable:next cyclomatic_complexity function_body_length
    func subscribeViewModel() {
        viewModel.scheduleUiState
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] model in
                    guard let self = self else {
                        return
                    }

                    switch model.state {
                    case .initial:
                        break
                    case .loading:
                        break
                    case .failed:
                        break
                    case .success:
                        onScheduleUpdated(model.data ?? [])
                        refreshEmptyStateVisibility()

                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                            self?.viewModel.acknowledgeSchedule()
                        }
                    case .blocked:
                        break
                    case .completed:
                        break
                    }
                }
            )
            .disposed(by: vmBag)
        viewModel.firstFetchUiState
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] model in
                    guard let self = self else {
                        return
                    }

                    switch model.state {
                    case .initial:
                        isEligibleToShowEmptyState = false
                    case .loading:
                        isEligibleToShowEmptyState = false
                    case .failed:
                        isEligibleToShowEmptyState = false
                        if let error = model.error {
                            handleError(
                                error,
                                onComplete: {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                                        self?.viewModel.acknowledgeFetchFirstPage()
                                    }
                                }
                            )
                        }
                    case .success:
                        isEligibleToShowEmptyState = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                            self?.viewModel.acknowledgeFetchFirstPage()
                        }
                    case .blocked:
                        isEligibleToShowEmptyState = false
                    case .completed:
                        isEligibleToShowEmptyState = true
                    }
                    refreshEmptyStateVisibility()
                }
            )
            .disposed(by: vmBag)
    }

    func unsubscribeViewModel() {
        vmBag = DisposeBag()
    }

    // MARK: Event Bus

    func registerEventBus() {
    }

    func unregisterEventBus() {
    }

    // MARK: Model

    func fetchContentIfEligible() {
        fetchContentLock.lock()
        defer {
            fetchContentLock.unlock()
        }

        guard shouldFetchContent else {
            return
        }
        shouldFetchContent = false

        viewModel.resetFetchFirstPage()
        viewModel.requestFetchFirstPage()
    }

    func onScheduleUpdated(_ schedules: [Domain.PostEntity]) {
        updateContents(schedules)
    }

    // Contents
    func updateContents(_ contents: [Domain.PostEntity]) {
        self.contents = contents
        refreshScheduleCellCache()

        cvContent?.reloadData()
    }

    func refreshScheduleCellCache() {
        contentsSizeCache.removeAll()
    }
}

// MARK: - COORDINATOR

private extension Presentation.UiKit.ListViewController {
    func goToDetailPage(content: Domain.PostEntity) {
        let vc = Presentation.UiKit.DetailViewController(
            nibName: nil,
            bundle: nil,
            content: content
        )
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - ANALYTICS

extension Presentation.UiKit.ListViewController {
}

// MARK: - DELEGATIONS

extension Presentation.UiKit.ListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        contents.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let content = contents[safeIndex: indexPath.item] else {
            fatalError("not yet implemented")
        }
        return self.collectionView(collectionView, cellForItemAt: indexPath, contentForGeneric: content)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath,
        contentForGeneric content: Domain.PostEntity
    ) -> UICollectionViewCell {
        guard let view = collectionView.dequeueReusableCell(
            withReuseIdentifier: Presentation.UiKit.ListCollectionCell.reuseIdentifier,
            for: indexPath
        ) as? Presentation.UiKit.ListCollectionCell else {
            fatalError("not yet implemented")
        }

        view.updateUi(content)

        return view
    }
}

extension Presentation.UiKit.ListViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard let content = contents[safeIndex: indexPath.item] else {
            return
        }
        onTapContent(content)
    }
}

extension Presentation.UiKit.ListViewController: UICollectionViewDelegateFlowLayout {
}

extension Presentation.UiKit.ListViewController {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    }

    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
}

extension Presentation.UiKit.ListViewController {
}

// MARK: - EXTENSION

// MARK: - STATIC DETACHABLE

// MARK: - TRACKING

#if DEBUG
extension Presentation.UiKit.ListViewController: LifetimeTrackable {
    class var lifetimeConfiguration: LifetimeConfiguration {
        LifetimeConfiguration(maxCount: 1)
    }
}
#endif
