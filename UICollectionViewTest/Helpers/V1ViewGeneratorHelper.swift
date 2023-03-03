//
// Created by engineering on 24/8/23.
// Copyright (c) 2023 beautyfulminds. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Lottie

extension Presentation.UiKit {
    public enum V1ViewGeneratorHelper {
        public static func generateGenericViewDesign() -> UIView {
            let view = UIView(frame: .zero)
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }

        public static func generateViewForSpaceBackdropV1Design() -> UIView {
            let view = generateGenericViewDesign()
            view.clipsToBounds = true

            if UIDevice.current.userInterfaceIdiom == .pad {
                let content = UIImageView(frame: .zero)
                content.translatesAutoresizingMaskIntoConstraints = false
                content.contentMode = .scaleAspectFill
                content.image = UIImage(named: "img_backdrop_space_v1_pad")

                view.addSubview(content)

                content.snp.makeConstraints { (make: ConstraintMaker) in
                    make.top.bottom
                            .equalToSuperview()

                    make.leading
                            .equalToSuperview()
                            .offset(-80)

                    make.trailing
                            .greaterThanOrEqualToSuperview()

                    make.width
                            .equalTo(content.snp.height)
                            .multipliedBy(2430.0 / 1366.0)
                            .priority(.high)
                }
            } else {
                let content = UIImageView(frame: .zero)
                content.translatesAutoresizingMaskIntoConstraints = false
                content.contentMode = .scaleAspectFill
                content.image = UIImage(named: "img_backdrop_space_v1_phone")

                view.addSubview(content)

                content.snp.makeConstraints { (make: ConstraintMaker) in
                    make.leading.bottom.trailing
                            .equalToSuperview()

                    make.height
                            .equalTo(content.snp.width)
                            .multipliedBy(2.133333) // 960.0 / 450.0
                }
            }

            return view
        }

        public static func generateViewForSpaceBackdropV2Design() -> UIView {
            let view = generateGenericViewDesign()
            view.clipsToBounds = true

            if UIDevice.current.userInterfaceIdiom == .pad {
                let ivTop = UIImageView(frame: .zero)
                ivTop.translatesAutoresizingMaskIntoConstraints = false
                ivTop.contentMode = .scaleAspectFill
                ivTop.image = UIImage(named: "img_backdrop_space_v2_pad_2")
                let ivBottom = UIImageView(frame: .zero)
                ivBottom.translatesAutoresizingMaskIntoConstraints = false
                ivBottom.contentMode = .scaleAspectFill
                ivBottom.image = UIImage(named: "img_backdrop_space_v2_pad_1")

                view.addSubview(ivTop)
                view.addSubview(ivBottom)

                ivTop.snp.makeConstraints { (make: ConstraintMaker) in
                    make.top
                            .equalToSuperview()
                            .offset(64)

                    make.leading.trailing
                            .equalToSuperview()

                    make.height
                            .equalTo(ivTop.snp.width)
                }

                ivBottom.snp.makeConstraints { (make: ConstraintMaker) in
                    make.leading.bottom.trailing
                            .equalToSuperview()

                    make.height
                            .equalTo(ivBottom.snp.width)
                }
            } else {
                let content = UIImageView(frame: .zero)
                content.translatesAutoresizingMaskIntoConstraints = false
                content.contentMode = .scaleAspectFill
                content.image = UIImage(named: "img_backdrop_space_v2_phone")

                view.addSubview(content)

                content.snp.makeConstraints { (make: ConstraintMaker) in
                    make.leading.bottom.trailing
                            .equalToSuperview()

                    make.height
                            .equalTo(content.snp.width)
                            .multipliedBy(2.1666667) // 975.0 / 450.0
                }
            }

            return view
        }

        // swiftlint:disable:next function_body_length
        static func generateViewGenerateWorksheetBackdrop(labelTag: Int) -> UIView {
            let view = Self.generateViewForSpaceBackdropV2Design()
            view.backgroundColor = UIColor.Genie.yankeesBlue

            let ivBanner = LottieAnimationView(frame: .zero)
            ivBanner.translatesAutoresizingMaskIntoConstraints = false
            ivBanner.loopMode = .loop
            ivBanner.animation = LottieAnimation.named("lottie_rocket_idle_loop", bundle: Bundle.main)
            ivBanner.play()

            let lbTitle = UILabel(frame: .zero)
            lbTitle.translatesAutoresizingMaskIntoConstraints = false
            lbTitle.font = FontHelper.SHSans.heavy.font(24)
            lbTitle.text = "lc_label_create_worksheet".localized
            lbTitle.adjustsFontSizeToFitWidth = true
            lbTitle.minimumScaleFactor = 0.5
            lbTitle.textColor = .white
            lbTitle.textAlignment = .center

            let lbSubtitle = UILabel(frame: .zero)
            lbSubtitle.translatesAutoresizingMaskIntoConstraints = false
            lbSubtitle.font = FontHelper.SHSans.regular.font(16)
            lbSubtitle.numberOfLines = 0
            lbSubtitle.textColor = .white
            lbSubtitle.textAlignment = .center
            lbSubtitle.tag = labelTag

            view.addSubview(ivBanner)
            view.addSubview(lbTitle)
            view.addSubview(lbSubtitle)

            ivBanner.snp.makeConstraints { make in
                make.centerX
                        .equalToSuperview()
                make.height
                        .equalTo(ivBanner.snp.width)
                        .multipliedBy(125.0 / 275.0)
                make.width
                        .lessThanOrEqualTo(256)
                make.width
                        .equalTo(256)
                        .priority(.medium)
            }

            lbTitle.snp.makeConstraints { make in
                make.top
                        .equalTo(ivBanner.snp.bottom)
                        .offset(12)
                make.leading
                        .greaterThanOrEqualToSuperview()
                        .offset(16)
                make.width
                        .equalTo(320)
                        .priority(.high)
                make.center
                        .equalToSuperview()
            }

            lbSubtitle.snp.makeConstraints { make in
                make.top
                        .equalTo(lbTitle.snp.bottom)
                        .offset(8)
                make.leading
                        .greaterThanOrEqualToSuperview()
                        .offset(16)
                make.width
                        .equalTo(320)
                        .priority(.high)
                make.centerX
                        .equalToSuperview()
            }

            return view
        }

        static func generateViewForActivityIndicatorDesign(containerBackground: UIColor) -> UIView {
            let view = UIView(frame: .zero)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = containerBackground

            let ivBanner = LottieAnimationView(frame: .zero)
            ivBanner.translatesAutoresizingMaskIntoConstraints = false
            ivBanner.loopMode = .loop
            ivBanner.animation = LottieAnimation.named("genieclass_core_small_rocket_anim", bundle: Bundle.main)
            ivBanner.play()

            view.addSubview(ivBanner)

            ivBanner.snp.makeConstraints { make in
                make.top
                        .greaterThanOrEqualToSuperview()
                make.center
                        .equalToSuperview()
                make.height
                        .equalTo(ivBanner.snp.width)
                make.width
                        .lessThanOrEqualTo(160)
                make.width
                        .equalTo(160)
                        .priority(.high)
            }

            return view
        }
    }
}

// MARK: - NAVIGATION

public extension Presentation.UiKit.V1ViewGeneratorHelper {
    public static func generateNavigationBackButton(color: UIColor? = nil) -> UIBarButtonItem {
        let image: UIImage?
        if let color {
            image = UIImage(named: "ic_fa_arrow_left_solid_24_padded")?.tinted(color: color)
        } else {
            image = UIImage(named: "ic_fa_arrow_left_solid_24_padded")
        }
        return UIBarButtonItem(
                image: image,
                style: .plain,
                target: nil,
                action: nil
        )
    }
}
