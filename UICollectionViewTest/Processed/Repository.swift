//
//  Repository.swift
//  UICollectionViewTest
//
//  Created by engineering on 16/7/24.
//

import Foundation
import RxSwift

protocol GenieClassRepository: AnyObject {
    // MARK: - Cache

    // MARK: - Local

    // MARK: - Remote
    func getPosts() -> Single<[Domain.PostEntity]>
}

final class GenieClassRepositoryImpl: GenieClassRepository {
    private let remoteDataSource: GenieClassRemoteDataSource

    init(
        remoteDataSource: GenieClassRemoteDataSource
    ) {
        self.remoteDataSource = remoteDataSource
    }
}

// MARK: - Cache

extension GenieClassRepositoryImpl {
}

// MARK: - Local

extension GenieClassRepositoryImpl {
}

// MARK: - Remote

extension GenieClassRepositoryImpl {
    func getPosts() -> Single<[Domain.PostEntity]> {
        remoteDataSource.getPosts()
    }
}
