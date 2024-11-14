//
//  Created by engineering on 23/8/24.
//

import Foundation
import RxSwift
import RxRelay
import LifetimeTracker
import SwiftDate

private let kLoadLimit = 20

// MARK: - LIFECYCLE AND CALLBACK

extension Presentation {
    final class ListViewModelImpl: ListViewModel {
        // MARK: Private Properties

        // @formatter:off
        private var _scheduleUiState = BehaviorRelay<
            Presentation.UiStateModel<
                [Domain.PostEntity],
                Presentation.OneTimeDataFetcherUiStateV1
        >
        >(value: Presentation.UiStateModel(data: [], error: nil, state: .initial))

        private var _firstFetchUiState = BehaviorRelay<
            Presentation.UiStateModel<
                (),
                Presentation.OneTimeDataFetcherUiStateV1
        >
        >(value: Presentation.UiStateModel(data: nil, error: nil, state: .initial))

        // @formatter:on

        private var classBag = DisposeBag()
        private var currentFetchFirstDisposable: Disposable?

        // MARK: Repositories

        private let genieClassRepository: GenieClassRepository

        // MARK: UseCases

        // MARK: Services

        // MARK: Public Properties

        // @formatter:off
        var scheduleUiState: Observable<
            Presentation.UiStateModel<
                [Domain.PostEntity],
                Presentation.OneTimeDataFetcherUiStateV1
            >
        > {
            _scheduleUiState.asObservable()
        }
        var firstFetchUiState: Observable<
            Presentation.UiStateModel<
                (),
                Presentation.OneTimeDataFetcherUiStateV1
            >
        > {
            _firstFetchUiState.asObservable()
        }
        // @formatter:on

        // MARK: Initialization
        init(
            genieClassRepository: GenieClassRepository
        ) {
            self.genieClassRepository = genieClassRepository

            resetFetchFirstPage()

#if DEBUG
            trackLifetime()
#endif
        }

        // MARK: Override Function

        // MARK: Callback

        // MARK: Public Function

        func reloadCredential() {
        }

        func resetFetchFirstPage() {
            var uiState = _firstFetchUiState.value

            disposeCurrentFetchFirstPage()

            uiState.state = .initial
            uiState.error = nil
            _firstFetchUiState.accept(uiState)

            var scheduleState = _scheduleUiState.value
            scheduleState.data = []
            scheduleState.error = nil
            scheduleState.state = .success
            _scheduleUiState.accept(scheduleState)
        }

        func requestFetchFirstPage() {
            doRequestFetchFirstPage()
        }

        func dropCurrentFetchFirstPage() {
            var uiState = _firstFetchUiState.value
            guard uiState.state == .loading else {
                return
            }

            disposeCurrentFetchFirstPage()

            uiState.state = .completed
            _firstFetchUiState.accept(uiState)
        }

        func acknowledgeFetchFirstPage() {
            var uiState = _firstFetchUiState.value

            disposeCurrentFetchFirstPage()

            uiState.state = .completed
            _firstFetchUiState.accept(uiState)
        }

        func acknowledgeSchedule() {
            var uiState = _scheduleUiState.value
            uiState.state = .completed
            _scheduleUiState.accept(uiState)
        }

        func cleanup() {
            disposeCurrentFetchFirstPage()
            classBag = DisposeBag()
        }

        // MARK: Deinitialization

        deinit {
            cleanup()
        }
    }
}

// MARK: - EXTERNAL SERVICE

private extension Presentation.ListViewModelImpl {
    func doRequestFetchFirstPage() {
        var uiState = _firstFetchUiState.value
        guard uiState.state == .initial
                || uiState.state == .failed
                || uiState.state == .success
                || uiState.state == .completed else {
            return
        }

        uiState.state = .loading
        _firstFetchUiState.accept(uiState)

        let disposable = genieClassRepository.getPosts()
            .subscribe(on: SerialDispatchQueueScheduler(qos: .utility))
            .observe(on: SerialDispatchQueueScheduler(qos: .utility))
            .subscribe(
                onSuccess: { [weak self] posts in
                    guard let self = self else {
                        return
                    }

                    var uiState = self._firstFetchUiState.value
                    uiState.state = .success
                    self._firstFetchUiState.accept(uiState)

                    var scheduleState = self._scheduleUiState.value
                    scheduleState.data = posts
                    scheduleState.state = .success
                    self._scheduleUiState.accept(scheduleState)
                },
                onFailure: { [weak self] error in
                    guard let self = self else {
                        return
                    }

                    let vmError = error.wrapViewAction(
                        onReplay: { [weak self] in
                            self?.doRequestFetchFirstPage()
                        },
                        onComplete: { [weak self] in
                            self
                        }
                    )

                    uiState.state = .failed
                    uiState.error = vmError
                    self._firstFetchUiState.accept(uiState)
                }
            )

        currentFetchFirstDisposable = disposable
        classBag.insert(disposable)
    }
}

// MARK: - PRIVATE FUNCTIONS

private extension Presentation.ListViewModelImpl {
    func disposeCurrentFetchFirstPage() {
        currentFetchFirstDisposable?.dispose()
        currentFetchFirstDisposable = nil
    }
}

// MARK: - STATIC DETACHABLE

// MARK: - TRACKING

#if DEBUG
extension Presentation.ListViewModelImpl: LifetimeTrackable {
    class var lifetimeConfiguration: LifetimeConfiguration {
        LifetimeConfiguration(maxCount: 1)
    }
}
#endif
