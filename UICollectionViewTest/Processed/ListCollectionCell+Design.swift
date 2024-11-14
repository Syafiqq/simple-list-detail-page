//
// Created by engineering on 20/8/24.
//

import Foundation
import UIKit
import SnapKit

// MARK: - DESIGN

internal extension Presentation.UiKit.ListCollectionCell {
    // swiftlint:disable:next function_body_length
    func initDesign() {
        // MARK: View Initialization
        let vwContainer = generateViewForContainerDesign()
        let ivHeader = generateImageForHeaderImageDesign()
        let vwContentContainer = generateGenericViewDesign()
        let lbTopic = generateLabelForTopicDesign()
        let lbDescription = generateLabelForDescriptionDesign()
        let lbDate = generateLabelForDateDesign()

        // MARK: View Graph
        contentView.addSubview(vwContainer)
        vwContainer.addSubview(ivHeader)
        vwContainer.addSubview(vwContentContainer)
        vwContentContainer.addSubview(lbTopic)
        vwContentContainer.addSubview(lbDescription)
        vwContentContainer.addSubview(lbDate)

        // MARK: View Constraints
        vwContainer.snp.makeConstraints { (make: ConstraintMaker) in
            // Align
            make.edges
                .equalToSuperview()
        }

        ivHeader.snp.makeConstraints { (make: ConstraintMaker) in
            make.leading.verticalEdges
                .equalToSuperview()
            make.width
                .equalTo(ivHeader.snp.height)
        }

        vwContentContainer.snp.makeConstraints { (make: ConstraintMaker) in
            // Align
            make.top
                .equalToSuperview()
            make.leading
                .equalTo(ivHeader.snp.trailing)
                .offset(16)
            make.trailing.bottom
                .equalToSuperview()
        }

        lbTopic.snp.makeConstraints { (make: ConstraintMaker) in
            make.top
                .equalToSuperview()
            make.horizontalEdges
                .equalToSuperview()
        }

        lbDescription.snp.makeConstraints { (make: ConstraintMaker) in
            make.top
                .equalTo(lbTopic.snp.bottom)
                .offset(8)
            make.horizontalEdges
                .equalToSuperview()
        }

        lbDate.snp.makeConstraints { (make: ConstraintMaker) in
            make.top
                .greaterThanOrEqualTo(lbDescription.snp.bottom)
                .offset(8)
            make.bottom.horizontalEdges
                .equalToSuperview()
        }

        lbDescription.setContentHuggingPriority(UILayoutPriority(249), for: .vertical)
        lbDate.setContentCompressionResistancePriority(.required, for: .vertical)

        // MARK: View Assign
        self.ivHeader = ivHeader
        self.lbTopic = lbTopic
        self.lbDescription = lbDescription
        self.lbDate = lbDate
    }

    private func generateGenericViewDesign() -> UIView {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

    private func generateViewForContainerDesign() -> UIView {
        let view = generateGenericViewDesign()
        view.backgroundColor = UIColor.white
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
}

// MARK: - COLOR

internal extension Presentation.UiKit.ListCollectionCell {
    enum Color {
    }
}
