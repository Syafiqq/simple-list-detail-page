//
// Created by engineering on 18/10/23.
//

import Foundation
import UIKit
import SnapKit

private let kActivityIndicatorTag = 0x12109254

public extension UIView {
    public func showLoadingRocket(delayAnimation: Bool = false, background: UIColor = .clear) {
        guard viewWithTag(kActivityIndicatorTag) == nil else {
            return
        }

        let view = Presentation.UiKit.V1ViewGeneratorHelper.generateViewForActivityIndicatorDesign(
                containerBackground: background
        )
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tag = kActivityIndicatorTag

        if delayAnimation {
            view.subviews.first?.isHidden = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak view] in
                view?.subviews.first?.isHidden = false
            }
        }

        addSubview(view)

        view.snp.makeConstraints { (make: ConstraintMaker) in
            make.edges
                    .equalToSuperview()
        }

        bringSubviewToFront(view)
    }

    public func hideLoadingRocket() {
        guard let view = viewWithTag(kActivityIndicatorTag) else {
            return
        }
        view.removeFromSuperview()
    }
}
