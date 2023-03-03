//
//  AtomicPrmitive.swift
//  UICollectionViewTest
//
//  Created by engineering on 11/2/24.
//

import Foundation

class AtomicString {
    private let queue = DispatchQueue(
        label: "\(Bundle.main.bundleIdentifier ?? "")_atomic_string",
        attributes: .concurrent
    )
    private var _value: String = ""

    var value: String {
        get {
            queue.sync { _value }
        }
        set {
            queue.async(flags: .barrier) {
                self._value = newValue
            }
        }
    }
}

class AtomicBool {
    private let queue = DispatchQueue(
        label: "\(Bundle.main.bundleIdentifier ?? "")_atomic_bool",
        attributes: .concurrent
    )
    private var _value: Bool = false

    var value: Bool {
        get {
            queue.sync { _value }
        }
        set {
            queue.async(flags: .barrier) {
                self._value = newValue
            }
        }
    }
}

class AtomicDictionary<Key: Hashable, Value> {
    private var internalDict = [Key: Value]()

    private let queue = DispatchQueue(
        label: "\(Bundle.main.bundleIdentifier ?? "")_atomic_dictionary",
        attributes: .concurrent
    )

    func getAll() -> [Key: Value] {
        queue.sync { internalDict }
    }

    subscript(key: Key) -> Value? {
        get {
            queue.sync { internalDict[key] }
        }
        set {
            queue.async(flags: .barrier) { [weak self] in
                self?.internalDict[key] = newValue
            }
        }
    }
}
