//
//  Created by engineering on 23/8/24.
//

import Foundation
import UIKit
import SnapKit

// MARK: - DESIGN

internal extension Presentation.UiKit.ListViewController {
    func initDesign() {
        // MARK: View Initialization
        let vwContainer = generateGenericViewDesign()
        let vwContentContainer = generateGenericViewDesign()
        let cvContent = generateCollectionForContentDesign()
        let vwEmptyState = generateViewForTableEmptyStateDesign()

        // MARK: View Graph
        view.addSubview(vwContainer)
        vwContainer.addSubview(vwContentContainer)
        vwContentContainer.addSubview(cvContent)
        cvContent.addSubview(vwEmptyState)

        // MARK: View Constraints

        vwContainer.snp.makeConstraints { (make: ConstraintMaker) in
            // Align
            make.edges
                .equalToSuperview()
        }

        vwContentContainer.snp.makeConstraints { (make: ConstraintMaker) in
            // Align
            make.edges
                .equalToSuperview()
        }

        cvContent.snp.makeConstraints { (make: ConstraintMaker) in
            // Align
            make.top
                .equalToSuperview()
                .offset(8)
            make.leading.trailing.bottom
                .equalToSuperview()
        }

        vwEmptyState.snp.makeConstraints { (make: ConstraintMaker) in
            make.center
                .equalToSuperview()
        }

        // MARK: View Assign
        self.vwContainer = vwContainer
        self.vwContentContainer = vwContentContainer
        self.cvContent = cvContent
        self.vwEmptyState = vwEmptyState
    }

    private func generateGenericViewDesign() -> UIView {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

    private func generateCollectionForContentDesign() -> UICollectionView {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }

    private func generateViewForTableEmptyStateDesign() -> UIView {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false

        let title = UILabel(frame: .zero)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textColor = .gray
        title.font = FontHelper.SHSans.regular.font(16)
        title.numberOfLines = 0
        title.textAlignment = .center
        title.text = "no items".localized

        view.addSubview(title)

        title.snp.makeConstraints { (make: ConstraintMaker) in
            make.edges.equalToSuperview()
        }

        return view
    }
}

// MARK: - COLOR

internal extension Presentation.UiKit.ListViewController {
    enum Color {
    }
}
