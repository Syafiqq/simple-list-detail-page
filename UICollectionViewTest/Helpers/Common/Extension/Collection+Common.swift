//
//  Collection+Common.swift
//  Geniebook
//
//  Created by DanYan on 05/11/21.
//  Copyright © 2021 Geniebook Pte. Ltd. All rights reserved.
//

import UIKit

extension UICollectionReusableView {
    static var reuseIdentifier: String {
        String(describing: Self.self)
    }

    static var reuseIdentifierForSkeleton: String {
        String(describing: Self.self) + "_" + "Skeleton"
    }
}

extension UITableViewCell {
    static var reuseIdentifier: String {
        String(describing: Self.self)
    }

    static var reuseIdentifierForSkeleton: String {
        String(describing: Self.self) + "_" + "Skeleton"
    }
}

extension UITableViewHeaderFooterView {
    static var reuseIdentifier: String {
        String(describing: Self.self)
    }

    static var reuseIdentifierForSkeleton: String {
        String(describing: Self.self) + "_" + "Skeleton"
    }
}
