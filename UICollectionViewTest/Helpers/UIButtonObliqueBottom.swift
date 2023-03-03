//
// Created by engineering on 24/8/23.
//

import Foundation
import SnapKit

extension Presentation.UiKit {
    public class UIButtonObliqueBottom: UIButton {
        public var foregroundColor: UIColor? {
            didSet {
                refreshColor()
            }
        }
        public var pressedColor: UIColor? {
            didSet {
                refreshColor()
            }
        }
        public var unPressedColor: UIColor? {
            didSet {
                refreshColor()
            }
        }
        public var backgroundColorShadow: UIColor? {
            didSet {
                refreshColor()
            }
        }
        public var disabledColor: UIColor? {
            didSet {
                refreshColor()
            }
        }

        override public var isEnabled: Bool {
            didSet {
                refreshState()
            }
        }

        override public init(frame: CGRect) {
            super.init(frame: frame)

            initDesign()
            initEvents()
        }

        public required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        @objc
        private func statePressed() {
            guard isEnabled else {
                stateDisabled()
                return
            }
            UIView.animate(
                    withDuration: 0.1,
                    delay: 0,
                    options: UIView.AnimationOptions.curveEaseIn,
                    animations: { [weak self] in
                        guard let self else {
                            return
                        }
                        self.backgroundColor = self.pressedColor ?? Color.pressedColor
                        self.transform = .identity.translatedBy(x: 0, y: 4)
                        self.layer.applySketchShadow(
                                color: self.backgroundColorShadow ?? Color.backgroundColorShadow,
                                alpha: 1.0,
                                x: 0.0,
                                y: 0.5,
                                blur: 0.0
                        )
                    },
                    completion: { _ in }
            )
        }

        @objc
        private func stateUnPressed() {
            guard isEnabled else {
                stateDisabled()
                return
            }
            UIView.animate(
                    withDuration: 0.1,
                    delay: 0,
                    options: UIView.AnimationOptions.curveEaseOut,
                    animations: { [weak self] in
                        guard let self else {
                            return
                        }
                        self.backgroundColor = self.unPressedColor ?? Color.unPressedColor
                        self.transform = .identity
                        self.layer.applySketchShadow(
                                color: self.backgroundColorShadow ?? Color.backgroundColorShadow,
                                alpha: 1.0,
                                x: 0.0,
                                y: 4.0,
                                blur: 0.0
                        )
                    },
                    completion: { _ in }
            )
        }

        @objc
        private func stateDisabled() {
            UIView.animate(
                    withDuration: 0.1,
                    delay: 0,
                    options: UIView.AnimationOptions.curveEaseIn,
                    animations: { [weak self] in
                        guard let self else {
                            return
                        }
                        self.backgroundColor = self.disabledColor ?? Color.disabledColor
                        self.transform = .identity.translatedBy(x: 0, y: 4)
                        self.layer.applySketchShadow(
                                color: self.backgroundColorShadow ?? Color.backgroundColorShadow,
                                alpha: 1.0,
                                x: 0.0,
                                y: 0.5,
                                blur: 0.0
                        )
                    },
                    completion: { _ in }
            )
        }

        private func refreshColor() {
            tintColor = foregroundColor ?? Color.foregroundColor
            setTitleColor(foregroundColor ?? Color.foregroundColor, for: .normal)
            refreshState()
        }

        private func refreshState() {
            stateUnPressed()
        }
    }
}

extension Presentation.UiKit.UIButtonObliqueBottom {
    private func initEvents() {
        addTarget(self, action: #selector(statePressed), for: .touchDown)
        addTarget(self, action: #selector(statePressed), for: .touchDragEnter)
        addTarget(self, action: #selector(stateUnPressed), for: .touchDragExit)
        addTarget(self, action: #selector(stateUnPressed), for: .touchUpInside)
        addTarget(self, action: #selector(stateUnPressed), for: .touchUpOutside)
    }

    private func initDesign() {
        layer.cornerRadius = 8
        contentEdgeInsets = UIEdgeInsets(vertical: 0, horizontal: 42)
        refreshColor()
    }
}

extension Presentation.UiKit.UIButtonObliqueBottom {
    enum Color {
        static let foregroundColor = UIColor.white
        static let backgroundColor = UIColor.Genie.accentSecondaryDark
        static let unPressedColor = backgroundColor
        static let pressedColor = backgroundColor
        static let backgroundColorShadow = UIColor.Genie.orangeMandarin
        static let disabledColor = UIColor.Genie.borderLight
    }
}
