// swiftlint:disable all
//
// Created by msyafiqq on 05/12/20.
// Copyright (c) 2020 Geniebook Pte. Ltd. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import RxAlamofire

struct ClientResponseError: RuntimeError {
    var message: String

    var internalError: (any Error)?

    var statusCode: Int
    var response: HTTPURLResponse
    var data: Data?
}

extension DataSource.Remote {
    final class GeniebookJsonAPI {
        static var shared = DataSource.Remote.GeniebookJsonAPI(apiService: DataSource.Remote.GeniebookJsonAPIJsonRequest.shared)
        private(set) var jsonRequestService: JsonRequest

        init(apiService: JsonRequest) {
            jsonRequestService = apiService
        }
    }
}

protocol JsonRequest: AnyObject {
    func get<T: Decodable>(
            to endPoint: String,
            param: [String: Any],
            header: [String: String],
            type: T.Type
    ) -> Single<T>

    func post<T: Decodable>(
            to endPoint: String,
            param: [String: Any],
            header: [String: String],
            type: T.Type
    ) -> Single<T>
}

extension DataSource.Remote {
final class GeniebookJsonAPIJsonRequest: JsonRequest {
    private var apiKey: String
    private var apiUid: () -> String
    private var baseUrl: () -> String
    private(set) var semaphoreProvider: () -> DispatchSemaphore
    private(set) var apiQueue: DispatchQueue
    private(set) var session: Session
    private(set) var requestTimeoutProvider: () -> TimeInterval

    init(
            apiKey: () -> String,
            apiUid: @escaping () -> String,
            baseUrl: @escaping () -> String,
            semaphoreProvider: @escaping () -> DispatchSemaphore,
            apiQueue: () -> DispatchQueue,
            session: Session,
            requestTimeoutProvider: @escaping () -> TimeInterval
    ) {
        self.apiKey = apiKey()
        self.apiUid = apiUid
        self.baseUrl = baseUrl
        self.semaphoreProvider = semaphoreProvider
        self.apiQueue = apiQueue()
        self.session = session
        self.requestTimeoutProvider = requestTimeoutProvider
    }

    static func isNetworkConnected() -> Bool {
        if let manager = NetworkReachabilityManager() {
            return manager.isReachable
        } else {
            return false
        }
    }

    func isRequestInvalid(endPoint: String) -> Error? {
        guard Self.isNetworkConnected() else {
            fatalError("not yet implemented")
        }
        guard URL(string: endPoint) != nil else {
            fatalError("not yet implemented")
        }
        return nil
    }

    func injectDefaultHeader(with dict: [String: String]) -> [String: String] {
        var header = [String: String]()
        header["api-key"] = apiKey
        if let apiUid = apiUid() as? String {
            header["UID"] = apiUid
        }
        return header.merging(dict, uniquingKeysWith: { (_, new) in new })
    }

    func injectBaseUrl(endPoint: String) -> String {
        "\(baseUrl())\(endPoint)"
    }

    func get<T: Decodable>(
            to endPoint: String,
            param: [String: Any],
            header: [String: String],
            type: T.Type
    ) -> Single<T> {
        let endPoint = injectBaseUrl(endPoint: endPoint)
        if let error = isRequestInvalid(endPoint: endPoint) {
            return Single.error(error)
        }
        let semaphore = semaphoreProvider()
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        return session.rx.request(
                                .get,
                                endPoint,
                                parameters: param,
                                encoding: URLEncoding.queryString,
                                headers: HTTPHeaders(injectDefaultHeader(with: header)),
                                requestModifier: { $0.timeoutInterval = self.requestTimeoutProvider() }
                        )
                        .flatMap {
                            $0
                                    .validate(validateClientResponseError)
                                    .validate()
                                    .rx
                                    .decodable(decoder: decoder)
                        }
                        .asSingle()
                        .catchAFErrorToBaseError()
    }

    func post<T: Decodable>(
            to endPoint: String,
            param: [String: Any],
            header: [String: String],
            type: T.Type
    ) -> Single<T> {
        let endPoint = injectBaseUrl(endPoint: endPoint)
        if let error = isRequestInvalid(endPoint: endPoint) {
            return Single.error(error)
        }
        let semaphore = semaphoreProvider()
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        return session.rx.request(
                        .post,
                        endPoint,
                        parameters: param,
                        encoding: URLEncoding.httpBody,
                        headers: HTTPHeaders(injectDefaultHeader(with: header)),
                        requestModifier: { $0.timeoutInterval = self.requestTimeoutProvider() }
                )
                .flatMap {
                    $0
                        .validate(validateClientResponseError)
                        .validate()
                        .rx
                        .decodable(decoder: decoder)
                }
                .asSingle()
                .catchAFErrorToBaseError()
    }
    }

    public static func validateClientResponseError(
            request: URLRequest?,
            response: HTTPURLResponse,
            data: Data?
    ) -> Swift.Result<Void, Error> {
        guard response.statusCode >= 400, response.statusCode < 500 else {
            return .success(())
        }
        return .failure(
            AFError.responseValidationFailed(
                reason: .customValidationFailed(
                    error: ClientResponseError(
                        message: "",
                        statusCode: response.statusCode,
                        response: response,
                        data: data
                    )
                )
            )
        )
    }
}

extension DataSource.Remote.GeniebookJsonAPIJsonRequest {
    static let shared = createShared()

    private static func apiKey() -> String {
        ""
    }

    private static func apiUid() -> String {
        "B73AFC4A6E7BD289566108D4A932FE5D"
    }

    private static func baseUrl() -> String {
        ""
    }

    private static func timeout() -> TimeInterval {
        120
    }

    private static func apiRequest() -> DispatchQueue {
        DispatchQueue.apiRequest
    }

    private static func apiSerialization() -> DispatchQueue {
        DispatchQueue.apiSerialization
    }

    private static func interceptorProvider() -> RequestInterceptor? {
        APIQueue.shared.apiQueueInterceptor
    }

    private static func semaphoreProvider() -> DispatchSemaphore {
        APIQueue.shared.queue
    }

    private static func apiQueue() -> DispatchQueue {
        DispatchQueue.apiDispatch
    }

    private static func createShared() -> DataSource.Remote.GeniebookJsonAPIJsonRequest {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = timeout()

        let session = Session(
                configuration: configuration,
                requestQueue: apiRequest(),
                serializationQueue: apiSerialization(),
                interceptor: interceptorProvider()
        )

        return DataSource.Remote.GeniebookJsonAPIJsonRequest(
                apiKey: apiKey,
                apiUid: apiUid,
                baseUrl: baseUrl,
                semaphoreProvider: semaphoreProvider,
                apiQueue: apiQueue,
                session: session,
                requestTimeoutProvider: timeout
        )
    }
}

extension Single where Trait == SingleTrait {
    func interceptSempahore(_ semaphore: DispatchSemaphore) -> Single<Element> {
        self
                .do(onSuccess: { _ in
                    semaphore.signal()
                })
                .do(onError: { _ in
                    semaphore.signal()
                })
    }
}

public extension Single where Trait == SingleTrait {
    func catchAFErrorToBaseError() -> Single<Element> {
        catchError { error in
            guard let afError = error as? AFError else {
                throw error
            }
            if case let AFError.responseValidationFailed(
                    reason: .customValidationFailed(error: validationError)
                ) = afError,
                let clientError = validationError as? ClientResponseError,
                let clientRawData = clientError.data,
                var clientData = try? JSONDecoder().decode(ApiDataResponseImpl<NoData>.self, from: clientRawData) {
                clientData.error = true
                throw clientData
            } else {
                var error = GBApiResponseImpl()
                error.error = true
                error.internalError = afError
                throw error
            }
        }
    }
}

public protocol RuntimeError: Error {
    var message: String { get }
    var internalError: Error? { get }
}

public protocol GBRequestError: RuntimeError {
    var error: Bool { get set }

    @available(*, deprecated, message: "Use errorCode instead")
    var error_code: String { get set }

    @available(*, deprecated, message: "Use errorMsg instead")
    var error_msg: String { get set }

    var errorCode: String { get set }
    var errorMsg: String { get set }
}

public protocol GBApiResponse: Codable, GBRequestError {
}

public struct GBApiResponseImpl: GBApiResponse {
    public var _errorCode: String = ""
    public var _errorMsg: String = ""

    public var error: Bool = true

    public var error_code: String {
        get {
            _errorMsg
        }
        set {
            _errorMsg = newValue
        }
    }

    public var error_msg: String {
        get {
            _errorMsg
        }
        set {
            _errorMsg = newValue
        }
    }

    public var message: String {
        _errorMsg
    }

    public var errorCode: String {
        get {
            _errorCode
        }
        set {
            _errorCode = newValue
        }
    }

    public var errorMsg: String {
        get {
            _errorCode
        }
        set {
            _errorCode = newValue
        }
    }

    public var internalError: Error?
}

public extension GBApiResponseImpl {
    private enum CodingKeys: CodingKey {
        case error
        case error_code
        case error_msg
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        error = try container.decodeIfPresent(Bool.self, forKey: .error) ?? true
        _errorCode = try container.decodeIfPresent(String.self, forKey: .error_code) ?? ""
        _errorMsg = try container.decodeIfPresent(String.self, forKey: .error_msg) ?? "unknown_error_occured".localiz()
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(error, forKey: .error)
        try container.encode(_errorCode, forKey: .error_code)
        try container.encode(_errorMsg, forKey: .error_msg)
    }
}


public enum RxSchedulerLayerType {
    case useCase
    case viewModel
    case viewController
    case remoteDataSource
    case localDataSource

    var label: String {
        get {
            return "\(Bundle.main.bundleIdentifier ?? "")_\(self.labelSuffix)"
        }
    }

    var labelSuffix: String {
        switch self {
        case .useCase: return "_rx_use-case"
        case .viewModel: return "_rx_view-model"
        case .viewController: return "_rx_view-controller"
        case .remoteDataSource: return "_rx_datasource-remote"
        case .localDataSource: return "_rx_datasource-local"
        }
    }
}

extension DispatchQueue {
    // @formatter:off
    static var io: DispatchQueue                        = DispatchQueue(label: "\(Bundle.main.bundleIdentifier ?? "")_io", qos: .userInitiated, attributes: .concurrent)
    static var apiSerialization: DispatchQueue          = DispatchQueue(label: "\(Bundle.main.bundleIdentifier ?? "")_api_serialization", qos: .utility)
    static var apiRequest: DispatchQueue                = DispatchQueue(label: "\(Bundle.main.bundleIdentifier ?? "")_api_request", qos: .utility)
    static var apiDispatch : DispatchQueue              = DispatchQueue(label: "\(Bundle.main.bundleIdentifier ?? "")_api_request_semaphore", qos: .userInitiated, attributes: .concurrent)
    static var backgroundDownload: DispatchQueue        = DispatchQueue(label: "\(Bundle.main.bundleIdentifier ?? "")_background_download", qos: .background, attributes: .concurrent)
    static var realm: DispatchQueue                     = DispatchQueue(label: "\(Bundle.main.bundleIdentifier ?? "")_realm", qos: .userInitiated)
    static var realmBackground: DispatchQueue           = DispatchQueue(label: "\(Bundle.main.bundleIdentifier ?? "")_realm_background", qos: .background)
    static var computation: DispatchQueue               = DispatchQueue(label: "\(Bundle.main.bundleIdentifier ?? "")_computation", qos: .utility, attributes: .concurrent)
    static var computationSerial: DispatchQueue         = DispatchQueue(label: "\(Bundle.main.bundleIdentifier ?? "")_computation_serial", qos: .utility)
    static var backgroundQuestionCreator: DispatchQueue = DispatchQueue(label: "\(Bundle.main.bundleIdentifier ?? "")_background_question_creator", qos: .background, attributes: .concurrent)
    static var firebaseDataQueue                        = DispatchQueue(label: "\(Bundle.main.bundleIdentifier ?? "")_firebase_data_queue", qos: .default)
    // @formatter:on

    static func rxScheduler(forLabelSuffix type: RxSchedulerLayerType, queue: DispatchQueue) -> SerialDispatchQueueScheduler {
        SerialDispatchQueueScheduler(
                queue: queue,
                internalSerialQueueName: "\(queue.label)\(type.labelSuffix)"
        )
    }
}

public extension Thread {
    class func printCurrent(_ message: @autoclosure () -> Any) {
        LogHelper.logVerbose("\rmessage: \(message())\r⚡️: \(Thread.current)\r" + "🏭: \(OperationQueue.current?.underlyingQueue?.label ?? "None")\r")
    }
}



import Foundation
import Alamofire

private let kDifference = 600
private let kSemaphoreCount = 10

class APIQueue {

    // MARK: - Properties
    let apiQueueInterceptor: RequestInterceptor?

    static let shared = APIQueue()

    private(set) var queue: DispatchSemaphore
    private var oldQueues = [Int64: DispatchSemaphore]()

    private init() {
        queue = Self.generateSemaphore()
        apiQueueInterceptor = LinearTooManyRequestRetryPolicy(retryLimit: 10)
    }

    func resetQueue() {
        storeOldQueue(queue)
        queue = Self.generateSemaphore()
    }

    private static func generateSemaphore() -> DispatchSemaphore {
        DispatchSemaphore(value: 10)
    }
}

private extension APIQueue {
    func storeOldQueue(_ queue: DispatchSemaphore) {
        oldQueues[Int64(Date().timeIntervalSince1970)] = queue
        removeOldQueue()
    }

    private func removeOldQueue() {
        DispatchQueue.computation.async { [weak self] in
            let now = Int64(Date().timeIntervalSince1970)
            let oldKeys = self?.oldQueues.keys.filter({ now - $0 > kDifference })
            oldKeys?.forEach { key in
                guard let queue = self?.oldQueues[key] else {
                    return
                }
                for _ in 0...kSemaphoreCount * 2 {
                    queue.signal()
                }
                self?.oldQueues.removeValue(forKey: key)
            }
        }
    }
}

// MARK: -

/// A retry policy that automatically retries idempotent requests for network connection lost errors. For more
/// information about retrying network connection lost errors, please refer to Apple's
/// [technical document](https://developer.apple.com/library/content/qa/qa1941/_index.html).
class TooManyRequestRetryPolicy: RetryPolicy {
    /// Creates a `TooManyRequestRetryPolicy` instance from the specified parameters.
    ///
    /// - Parameters:
    ///   - retryLimit:              The total number of times the request is allowed to be retried.
    ///                              `RetryPolicy.defaultRetryLimit` by default.
    ///   - exponentialBackoffBase:  The base of the exponential backoff policy.
    ///                              `RetryPolicy.defaultExponentialBackoffBase` by default.
    ///   - exponentialBackoffScale: The scale of the exponential backoff.
    ///                              `RetryPolicy.defaultExponentialBackoffScale` by default.
    ///   - retryableHTTPMethods:    The idempotent http methods to retry.
    ///                              `RetryPolicy.defaultRetryableHTTPMethods` by default.
    public init(retryLimit: UInt = RetryPolicy.defaultRetryLimit,
                exponentialBackoffBase: UInt = RetryPolicy.defaultExponentialBackoffBase,
                exponentialBackoffScale: Double = RetryPolicy.defaultExponentialBackoffScale,
                retryableHTTPMethods: Set<HTTPMethod> = RetryPolicy.defaultRetryableHTTPMethods) {
        super.init(retryLimit: retryLimit,
                exponentialBackoffBase: exponentialBackoffBase,
                exponentialBackoffScale: exponentialBackoffScale,
                retryableHTTPMethods: [HTTPMethod.post],
                retryableHTTPStatusCodes: [429],
                retryableURLErrorCodes: [])
    }
}

class LinearTooManyRequestRetryPolicy: TooManyRequestRetryPolicy {
    override func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> ()) {
        if request.retryCount < retryLimit, shouldRetry(request: request, dueTo: error) {
            completion(.retryWithDelay(TimeInterval(request.retryCount) + 1.0))
        } else {
            completion(.doNotRetry)
        }
    }
}

protocol ErrorDataDelegate: Error { // swiftlint:disable:this class_delegate_protocol
    var error: Bool { get set }
    var error_code: String { get set }
    var error_msg: String { get set }
}

protocol ApiResponseProtocol: Codable, ErrorDataDelegate {
}

protocol ApiDataResponse: ApiResponseProtocol {
    associatedtype DataResponse

    var data: DataResponse? { get }
}

struct ApiDataResponseImpl<T: Codable>: ApiDataResponse {
    typealias DataResponse = T

    enum CodingKeys: String, CodingKey {
        case error = "error"
        case error_code = "errorCode"
        case error_msg = "errorMsg"
        case data = "data"
        case msg = "msg"
        case message = "message"
        case code = "code"
    }

    var error: Bool = false
    var msg: String = ""
    var error_code: String = ""
    var error_msg: String = ""
    var message: String = ""
    var code: Int = 0
    var data: T?
}

extension ApiDataResponseImpl where T: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // @formatter:off
        code = try container.decodeIfPresent(Int.self, forKey: .code) ?? 0
        message = try container.decodeIfPresent(String.self, forKey: .message) ?? ""

        error = try container.decodeIfPresent(Bool.self, forKey: .error) ?? (code != 0)
        msg = try container.decodeIfPresent(String.self, forKey: .msg) ?? ""
        error_code = try container.decodeIfPresent(String.self, forKey: .error_code) ?? ""
        error_msg = try container.decodeIfPresent(String.self, forKey: .error_msg) ?? "unknown_error_occured".localized
        data = try container.decodeIfPresent(T.self, forKey: .data)

        error_code = error_code.isEmpty ? String(code) : error_code
        error_msg = !message.isEmpty ? message : error_msg
        // @formatter:on
    }
}

extension ApiDataResponse {
    func throwErrorFromApiV1(
            extensions: ((Self) throws -> Void)...
    ) throws -> Self {
        if error {
            if error_code == "300-05" {
                throw StudentError.notPremiumSubscription
            } else {
                for `extension` in extensions {
                    try `extension`(self)
                }
                throw self
            }
        } else {
            return self
        }
    }
}

extension ApiResponseProtocol {
    func throwErrorFromApiV1(
            extensions: ((Self) throws -> Void)...
    ) throws -> Self {
        if error {
            if error_code == "300-05" {
                throw StudentError.notPremiumSubscription
            } else {
                for `extension` in extensions {
                    try `extension`(self)
                }
                throw self
            }
        } else {
            return self
        }
    }
}

extension ApiDataResponse {
    func mapToData() throws -> DataResponse {
        guard let data = data else {
            throw ConversionError.failedToConvertData
        }
        return data
    }

    func mapToNullableData() throws -> DataResponse? {
        data
    }
}

public class CrashlyticsHelper {
    public enum DomainType {
        case genieAsk
        case nonFatal
        case iap
        case upgradeRequest
        case language
        case unknownFatal
        case apiRequestError(String, String, String)
        case question
        case realmAccessError(String, String, String)
        case threadError(String)
    }
}

extension Single where Trait == SingleTrait {
    func sendErrorToCrashlytics(
            _ url: String?,
            _ data: @escaping @autoclosure () -> [String: Any],
            _ domain: CrashlyticsHelper.DomainType = .nonFatal
    ) -> Single<Element> {
        self
    }
}

extension Observable {
    func sendErrorToCrashlytics(
            _ url: String?,
            _ data: @escaping @autoclosure () -> [String: Any],
            _ domain: CrashlyticsHelper.DomainType = .nonFatal
    ) -> Observable<Element> {
        self
    }
}

extension Completable {
    func sendErrorToCrashlytics(
            _ url: String?,
            _ data: @escaping @autoclosure () -> [String: Any],
            _ domain: CrashlyticsHelper.DomainType = .nonFatal
    ) -> Completable {
        self
    }
}

struct NoData: Codable {
}
// swiftlint:enable all
