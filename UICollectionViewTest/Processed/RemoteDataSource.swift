//
//  RemoteDataSource.swift
//  UICollectionViewTest
//
//  Created by engineering on 7/2/24.
//

import Foundation
import RxSwift
import CodableWrappers

protocol GenieClassRemoteDataSource {
    func getPosts() -> Single<[Domain.PostEntity]>
}

extension DataSource.Remote.GeniebookJsonAPI: GenieClassRemoteDataSource {
    func getPosts() -> Single<[Domain.PostEntity]> {
        let endpoint = "posts"

        let param: [String: Any?] = [
            :
        ]

        return jsonRequestService
            .get(
                to: endpoint,
                param: param.compactMapValues {
                    $0
                },
                header: [:],
                type: [Domain.PostEntity].self
            )
    }
}

private extension ApiDataResponse {
}
