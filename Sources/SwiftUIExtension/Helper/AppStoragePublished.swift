//
//  File.swift
//  
//
//  Created by hujinyou on 2024/5/30.
//

import SwiftUI
import Combine

@propertyWrapper
public struct AppStoragePublished<T>: DynamicProperty {
    @AppStorage private var storageValue: T
    private var publisher = PassthroughSubject<T, Never>()
    
    public var wrappedValue: T {
        get { storageValue }
        nonmutating set {
            storageValue = newValue
            publisher.send(newValue)
        }
    }
    
    public var projectedValue: AnyPublisher<T, Never> {
        publisher.eraseToAnyPublisher()
    }
}

public extension AppStoragePublished {
    public init(wrappedValue: T, _ key: String) where T == Bool {
        self._storageValue = AppStorage(wrappedValue: wrappedValue, key)
        self.publisher.send(wrappedValue)
    }

    public init(wrappedValue: T, _ key: String) where T == Int {
        self._storageValue = AppStorage(wrappedValue: wrappedValue, key)
        self.publisher.send(wrappedValue)
    }
    
    public init(wrappedValue: T, _ key: String) where T == Double {
        self._storageValue = AppStorage(wrappedValue: wrappedValue, key)
        self.publisher.send(wrappedValue)
    }

    public init(wrappedValue: T, _ key: String) where T == String {
        self._storageValue = AppStorage(wrappedValue: wrappedValue, key)
        self.publisher.send(wrappedValue)
    }
    
    public init(wrappedValue: T, _ key: String) where T == URL {
        self._storageValue = AppStorage(wrappedValue: wrappedValue, key)
        self.publisher.send(wrappedValue)
    }
    
    public init(wrappedValue: T, _ key: String) where T == Data {
        self._storageValue = AppStorage(wrappedValue: wrappedValue, key)
        self.publisher.send(wrappedValue)
    }
    
    public init(wrappedValue: T, _ key: String) where T: RawRepresentable, T.RawValue == Int {
        self._storageValue = AppStorage(wrappedValue: wrappedValue, key)
        self.publisher.send(wrappedValue)
    }

    public init(wrappedValue: T, _ key: String) where T: RawRepresentable, T.RawValue == String {
        self._storageValue = AppStorage(wrappedValue: wrappedValue, key)
        self.publisher.send(wrappedValue)
    }
}
