//
//  Created by engineering on 23/8/24.
//

import Foundation
import UIKit
import SnapKit

// MARK: - DESIGN

internal extension Presentation.UiKit.DetailViewController {
    // swiftlint:disable:next function_body_length
    func initDesign() {
        // MARK: View Initialization
        let vwContainer = generateGenericViewDesign()
        let svContainer = generateScrollForCustomViewDesign()
        let vwSvContainer = generateGenericViewDesign()
        let vwContentContainer = generateGenericViewDesign()
        let ivHeader = generateImageForHeaderImageDesign()
        let lbTopic = generateLabelForTopicDesign()
        let lbDate = generateLabelForDateDesign()
        let lbPublishedDate = generateLabelForPublishedDateDesign()
        let lbDescription = generateLabelForDescriptionDesign()

        // MARK: View Graph
        view.addSubview(vwContainer)
        vwContainer.addSubview(svContainer)
        svContainer.addSubview(vwSvContainer)
        vwSvContainer.addSubview(vwContentContainer)
        vwContentContainer.addSubview(ivHeader)
        vwContentContainer.addSubview(lbTopic)
        vwContentContainer.addSubview(lbDate)
        vwContentContainer.addSubview(lbPublishedDate)
        vwContentContainer.addSubview(lbDescription)

        // MARK: View Constraints

        vwContainer.snp.makeConstraints { (make: ConstraintMaker) in
            // Align
            make.edges
                .equalToSuperview()
        }

        svContainer.snp.makeConstraints { (make: ConstraintMaker) in
            make.directionalEdges
                    .equalToSuperview()
        }

        vwSvContainer.snp.makeConstraints { (make: ConstraintMaker) in
            make.directionalEdges
                    .equalTo(svContainer.contentLayoutGuide)

            make.width
                    .equalTo(svContainer.frameLayoutGuide)
            make.height
                    .equalTo(svContainer.frameLayoutGuide)
                    .priority(749)
        }

        vwContentContainer.snp.makeConstraints { (make: ConstraintMaker) in
            // Align
            make.top.horizontalEdges
                .equalToSuperview()
                .inset(UIEdgeInsets(all: 8))
            make.bottom
                .lessThanOrEqualToSuperview()
                .inset(UIEdgeInsets(all: 8))
        }

        ivHeader.snp.makeConstraints { (make: ConstraintMaker) in
            make.top.horizontalEdges
                .equalToSuperview()
            make.height
                .equalTo(ivHeader.snp.width)
                .multipliedBy(
                    UIDevice.current.userInterfaceIdiom == .pad
                        ? 2.0 / 4.0
                        : 3.0 / 4.0
                )
        }

        lbTopic.snp.makeConstraints { (make: ConstraintMaker) in
            make.top
                .equalTo(ivHeader.snp.bottom)
                .offset(32)
            make.horizontalEdges
                .equalToSuperview()
        }

        lbDate.snp.makeConstraints { (make: ConstraintMaker) in
            make.top
                .equalTo(lbTopic.snp.bottom)
                .offset(8)
            make.horizontalEdges
                .equalToSuperview()
        }

        lbPublishedDate.snp.makeConstraints { (make: ConstraintMaker) in
            make.top
                .equalTo(lbDate.snp.bottom)
                .offset(32)
            make.horizontalEdges
                .equalToSuperview()
        }

        lbDescription.snp.makeConstraints { (make: ConstraintMaker) in
            make.top
                .equalTo(lbPublishedDate.snp.bottom)
                .offset(8)
            make.bottom.horizontalEdges
                .equalToSuperview()
        }

        // MARK: View Assign
        self.ivHeader = ivHeader
        self.lbTopic = lbTopic
        self.lbDescription = lbDescription
        self.lbDate = lbDate
        self.lbPublishedDate = lbPublishedDate
    }

    private func generateGenericViewDesign() -> UIView {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

    func generateScrollForCustomViewDesign() -> UIScrollView {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = true
        return view
    }

    private func generateImageForHeaderImageDesign() -> UIImageView {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 16
        view.image = UIImage(named: "default_genieclass_thumbnail")
        return view
    }

    private func generateLabelForTopicDesign() -> UILabel {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = FontHelper.SHSans.bold.font(24)
        view.numberOfLines = 2
        view.textColor = UIColor.Genie.GBPNavy
        return view
    }

    private func generateLabelForDescriptionDesign() -> UILabel {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = FontHelper.SHSans.regular.font(16)
        view.numberOfLines = 0
        view.textColor = UIColor.Genie.labelSubtitle
        return view
    }

    private func generateLabelForDateDesign() -> UILabel {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = FontHelper.SHSans.bold.font(12)
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.5
        return view
    }

    private func generateLabelForPublishedDateDesign() -> UILabel {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = FontHelper.SHSans.regular.font(12)
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.5
        return view
    }
}

// MARK: - COLOR

internal extension Presentation.UiKit.DetailViewController {
    enum Color {
    }
}
