//
//  Created by engineering on 14/11/24.
//

//
//  DomainEntity.swift
//  UICollectionViewTest
//
//  Created by engineering on 7/2/24.
//

import Foundation
import CodableWrappers

extension Domain {
    struct PostEntity: Codable {
        @CodingUses<StringOrIntToStringStaticCoder> var id: String?
        var slug: String?
        var url: String?
        var title: String?
        var content: String?
        var image: String?
        var thumbnail: String?
        var status: String?
        var category: String?
        var publishedAt: String?
        var updatedAt: String?
        @CodingUses<StringOrIntToStringStaticCoder> var userId: String?
    }
}
