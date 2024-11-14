//
// Created by engineering on 20/8/24.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxRelay
import Kingfisher

// MARK: - LIFECYCLE AND CALLBACK

extension Presentation.UiKit {
    class ListCollectionCell: UICollectionViewCell {
        // MARK: Outlets
        internal var ivHeader: UIImageView?
        internal var lbTopic: UILabel?
        internal var lbDescription: UILabel?
        internal var lbDate: UILabel?

        // MARK: ViewModel

        // MARK: Private Properties

        private var _presenterId: String?

        // Rx

        // Credential

        // MARK: Data

        var presenterId: String? {
            _presenterId
        }

        // MARK: Public Properties

        // MARK: Initialization
        override init(frame: CGRect) {
            super.init(frame: frame)

            initDesign()
            initViews()
            initEvents()
            initData()
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        // MARK: Lifecycle

        // MARK: Override Function

        override func prepareForReuse() {
            super.prepareForReuse()
            _presenterId = nil
        }

        // MARK: Callback

        // MARK: Public Function

        func updateUi(_ data: Domain.PostEntity) {
            _presenterId = data.id

            lbTopic?.text = data.title ?? "-"

            lbDescription?.text = data.content ?? "-"

            lbDate?.text = data.updatedAt ?? "-"

            // Update Header Image
            updateHeaderImage(thumbnail: data.thumbnail)
        }

        // MARK: Deinitialization

        deinit {
        }
    }
}

// MARK: - PRIVATE FUNCTIONS

private extension Presentation.UiKit.ListCollectionCell {
    // MARK: Init Functions
    func initViews() {
        backgroundColor = .clear
    }

    func initEvents() {
    }

    func initData() {
    }

    // MARK: Views

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

    // MARK: ViewModel

    // MARK: Model
}

// MARK: - DELEGATIONS

// MARK: - EXTENSION

// MARK: - STATIC DETACHABLE

// MARK: - TRACKING
