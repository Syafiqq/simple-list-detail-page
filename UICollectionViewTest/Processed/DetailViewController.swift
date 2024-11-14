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
    class DetailViewController: V1UIViewController {
        // MARK: Outlets
        internal var ivHeader: UIImageView?
        internal var lbTopic: UILabel?
        internal var lbDescription: UILabel?
        internal var lbDate: UILabel?
        internal var lbPublishedDate: UILabel?

        // MARK: ViewModel

        // MARK: Service

        // @formatter:off
        // @formatter:on

        // MARK: Private Properties

        // Rx

        // CollectionView

        // Credential

        // Scroll

        // MARK: Data

        private let content: Domain.PostEntity

        // Vc Transition
        private var isVcTransitionInProgress = false

        // MARK: Public Properties

        // MARK: Initialization
        init(
            nibName nibNameOrNil: String?,
            bundle nibBundleOrNil: Bundle?,
            content: Domain.PostEntity
        ) {
            self.content = content
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
        }

        private func onViewDidAppear(_ animated: Bool) {
        }

        private func onViewWillDisappear(_ animated: Bool) {
            unsubscribeViewModel()
        }

        private func onViewDidDisappear(_ animated: Bool) {
        }

        private func onViewWillLayoutSubviews() {
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
        }

        // MARK: Public Function

        // MARK: Deinitialization

        deinit {
            unsubscribeViewModel()
            unregisterEventBus()
        }
    }
}

// MARK: - PRIVATE FUNCTIONS

private extension Presentation.UiKit.DetailViewController {
    // MARK: Init Functions
    func initViews() {
        view.backgroundColor = .white
        view.tintColor = .orange

        // Nav Bar
        navigationItem.title = "Detail"
    }

    func initEvents() {
        unregisterEventBus()
        registerEventBus()
    }

    func initData() {
        lbTopic?.text = content.title ?? "-"

        lbDescription?.text = content.content ?? "-"

        lbDate?.text = content.updatedAt ?? "-"

        lbPublishedDate?.text = "Published at: \(content.publishedAt ?? "-")"

        // Update Header Image
        updateHeaderImage(thumbnail: content.thumbnail)
    }

    // MARK: Views

    // Navigation

    func updateHeaderImage(thumbnail: String?) {
        if let thumbnail,
           let url = URL(string: "\(thumbnail)") {
            let placeholderImage = UIImage(named: "default_genieclass_thumbnail")
            ivHeader?.kf.indicatorType = .activity
            ivHeader?.kf.setImage(
                with: url,
                placeholder: placeholderImage,
                options: Presentation.KingfisherHelper.GenieClass.recordedHeaderOptions
            ) { [weak self] result in
                switch result {
                case .success:
                    break
                case .failure(let error):
                    if !error.isTaskCancelled && !error.isNotCurrentTask {
                        self?.setDefaultHeaderImage()
                    }
                }
            }
        } else {
            setDefaultHeaderImage()
        }
    }

    func setDefaultHeaderImage() {
        ivHeader?.image = UIImage(named: "default_genieclass_thumbnail")
    }

    // Loading

    // Error

    // MARK: ViewModel

    func subscribeViewModel() {
    }

    func unsubscribeViewModel() {
    }

    // MARK: Event Bus

    func registerEventBus() {
    }

    func unregisterEventBus() {
    }

    // MARK: Model
}

// MARK: - COORDINATOR

private extension Presentation.UiKit.DetailViewController {
}

// MARK: - ANALYTICS

extension Presentation.UiKit.DetailViewController {
}

// MARK: - DELEGATIONS

extension Presentation.UiKit.DetailViewController {
}

// MARK: - EXTENSION

// MARK: - STATIC DETACHABLE

// MARK: - TRACKING

#if DEBUG
extension Presentation.UiKit.DetailViewController: LifetimeTrackable {
    class var lifetimeConfiguration: LifetimeConfiguration {
        LifetimeConfiguration(maxCount: 1)
    }
}
#endif
