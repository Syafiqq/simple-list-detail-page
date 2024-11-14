//
// Created by engineering on 23/8/24.
//

import Foundation
import RxSwift

protocol ListViewModel: AnyObject {
    // @formatter:off
    var scheduleUiState: Observable<
        Presentation.UiStateModel<
            [Domain.PostEntity],
            Presentation.OneTimeDataFetcherUiStateV1
        >
    > { get }

    var firstFetchUiState: Observable<
        Presentation.UiStateModel<
            (),
            Presentation.OneTimeDataFetcherUiStateV1
        >
    > { get }

    // @formatter:on

    func reloadCredential()

    func resetFetchFirstPage()
    func requestFetchFirstPage()
    func dropCurrentFetchFirstPage()
    func acknowledgeFetchFirstPage()

    func acknowledgeSchedule()

    func cleanup()
}
