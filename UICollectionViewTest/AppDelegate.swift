//
//  AppDelegate.swift
//  UICollectionViewTest
//
//  Created by engineering on 3/3/23.
//

import UIKit
import AlamofireNetworkActivityLogger
import LifetimeTracker
import XLPagerTabStrip
import SnapKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    // MARK: - AppDelegate Lifecycle

    func application(
            _ application: UIApplication,
            willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
            // swiftlint:disable:previous discouraged_optional_collection
    ) -> Bool {
        true
    }

    func application(
            _ application: UIApplication,
            didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
            // swiftlint:disable:previous discouraged_optional_collection
    ) -> Bool {
        RealmHelper.setup()
        #if DEBUG
        LifetimeTracker.setup(onUpdate: LifetimeTrackerDashboardIntegration(visibility: .visibleWithIssuesDetected, style: .circular).refreshUI)
        #endif
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
}

class Segment1Vc: UIViewController, IndicatorInfoProvider {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init(coder: NSCoder) {
        fatalError("not yet implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .random.withAlphaComponent(0.2)
    }

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        IndicatorInfo(
                title: "Segment Vc 1"
        )
    }
}

class Segment2Vc: UIViewController, IndicatorInfoProvider {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init(coder: NSCoder) {
        fatalError("not yet implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .random.withAlphaComponent(0.2)
    }

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        IndicatorInfo(
                title: "Segment Vc 2"
        )
    }
}

extension Presentation {
    struct DummyPresenter {
        let content: String
    }
}

extension Presentation.UiKit {
    class DummyCell: UICollectionViewCell {
        var lbText: UILabel?
        // MARK: - Outlets
        // MARK: - Constructors
        override init(frame: CGRect) {
            super.init(frame: frame)

            let vwContainer = generateGenericViewDesign()
            let lbText = generateSegmentTitleDesign()

            contentView.addSubview(vwContainer)
            vwContainer.addSubview(lbText)

            vwContainer.snp.makeConstraints { (make: ConstraintMaker) in
                // Align
                make.edges
                        .equalToSuperview()
            }

            lbText.snp.makeConstraints { (make: ConstraintMaker) in
                // Align
                make.top.directionalHorizontalEdges
                        .equalToSuperview()
                        .inset(UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
                make.bottom
                        .lessThanOrEqualToSuperview()
                        .offset(-8)
            }

            lbText.backgroundColor = .blue.withAlphaComponent(0.5)
            contentView.backgroundColor = .random.withAlphaComponent(0.2)
            self.lbText = lbText
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        private func generateGenericViewDesign() -> UIView {
            let view = UIView(frame: .zero)
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }
        
        private func generateSegmentTitleDesign() -> UILabel {
            let view = UILabel(frame: .zero)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.font = FontHelper.DMSans.medium.font(14.0)
            view.textColor = UIColor.Genie.textPrimary
            view.numberOfLines = 0
            return view
        }
    }
}
