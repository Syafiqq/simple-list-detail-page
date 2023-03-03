//
// Created by engineering on 9/8/22.
// Copyright (c) 2022 Geniebook Pte. Ltd. All rights reserved.
//

import Foundation
import UIKit

enum AppCompatHelper {
    static weak var keyWindow: UIWindow? {
        #if swift(>=5.1)
        if #available(iOS 13, *) {
            return UIApplication.shared.connectedScenes
                    .compactMap({ $0 as? UIWindowScene })
                    .flatMap({ $0.windows })
                    .first(where: { $0.isKeyWindow })
        } else {
            return UIApplication.shared.keyWindow
        }
        #else
        return UIApplication.shared.keyWindow
        #endif
    }
}
