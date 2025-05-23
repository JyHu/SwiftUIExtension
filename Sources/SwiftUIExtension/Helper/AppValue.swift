//
//  AppValue.swift
//  SwiftUIExtension
//
//  Created by hujinyou on 2025/4/13.
//

import SwiftUI

/// `AppValueKey` 协议用于描述一个支持 `@AppStorage` 存储的键值配置。
///
/// 你只需实现：
/// - `key`：用于作为存储时的唯一 Key。
/// - `default`：默认值，在未设置或读取失败时使用。
///
/// 示例：
/// ```swift
/// enum LaunchMode: Int, CaseIterable, Identifiable {
///     case normal, safe, debug
///     var id: Self { self }
/// }
///
/// enum SIDs {
///     struct Default<T>: AppValueKey {
///         typealias Value = T
///         let key: String
///         let `default`: T
///     }
///
///     static let showSidebar = Default<Bool>(key: "com.example.showSidebar", default: true)
///     static let username = Default<String>(key: "com.example.username", default: "Guest")
///     static let launchMode = Default<LaunchMode>(key: "com.example.launchMode", default: .normal)
/// }
/// ```
public protocol AppValueKey {
    associatedtype Value
    var key: String { get }
    var `default`: Value { get }
}

public struct DefaultAppValue<T>: AppValueKey {
    public typealias Value = T
    public let key: String
    public let `default`: T
    
    public init(key: String, default: T) {
        self.key = key
        self.default = `default`
    }
}

public extension AppValueKey {
    /// 尝试从 UserDefaults 中获取用户设置的值（可能为 nil）
    func storedValue() -> Value? {
        UserDefaults.standard.object(forKey: key) as? Value
    }
    
    /// 获取用户设置的值，如不存在则返回默认值
    func resolvedValue() -> Value {
        storedValue() ?? self.default
    }
}

// RawRepresentable 特化版本
public extension AppValueKey where Value: RawRepresentable {
    func storedValue() -> Value? {
        if let raw = UserDefaults.standard.object(forKey: key) as? Value.RawValue {
            return Value(rawValue: raw)
        }
        return nil
    }

    func resolvedValue() -> Value {
        storedValue() ?? self.default
    }
}

/// `AppValue` 是一个用于简化 `@AppStorage` 使用的属性包装器。
///
/// 它通过传入实现了 `AppValueKey` 的结构体来统一声明方式，
/// 自动推断所需类型并提供默认值支持。
///
/// ✅ 支持的类型：
/// - `String`
/// - `Bool`
/// - `Int`
/// - `Double`
/// - `Data`
/// - `URL`
/// - 枚举（RawValue 为 String 或 Int）
///
/// ✅ 使用方式：
/// ```swift
/// struct ContentView: View {
///     @AppValue(SIDs.showSidebar) private var showSidebar: Bool
///     @AppValue(SIDs.username) private var username: String
///     @AppValue(SIDs.launchMode) private var mode: LaunchMode
///
///     var body: some View {
///         VStack {
///             Toggle("显示侧边栏", isOn: $showSidebar)
///             TextField("用户名", text: $username)
///             Picker("启动模式", selection: $mode) {
///                 ForEach(LaunchMode.allCases) {
///                     Text(String(describing: $0)).tag($0)
///                 }
///             }
///         }
///         .padding()
///     }
/// }
/// ```
@propertyWrapper
public struct AppValue<V>: DynamicProperty {
    @AppStorage private var value: V

    public var wrappedValue: V {
        get { value }
        nonmutating set { value = newValue }
    }

    public var projectedValue: Binding<V> {
        $value
    }
}

public extension AppValue {
    init<K: AppValueKey>(_ key: K) where K.Value == String, K.Value == V {
        self._value = AppStorage(wrappedValue: key.default, key.key)
    }

    init<K: AppValueKey>(_ key: K) where K.Value == Bool, K.Value == V {
        self._value = AppStorage(wrappedValue: key.default, key.key)
    }

    init<K: AppValueKey>(_ key: K) where K.Value == Int, K.Value == V {
        self._value = AppStorage(wrappedValue: key.default, key.key)
    }

    init<K: AppValueKey>(_ key: K) where K.Value == Double, K.Value == V {
        self._value = AppStorage(wrappedValue: key.default, key.key)
    }

    init<K: AppValueKey>(_ key: K) where K.Value == Data, K.Value == V {
        self._value = AppStorage(wrappedValue: key.default, key.key)
    }

    init<K: AppValueKey>(_ key: K) where K.Value == URL, K.Value == V {
        self._value = AppStorage(wrappedValue: key.default, key.key)
    }

    // MARK: - 枚举支持（RawRepresentable: String）

    init<K: AppValueKey>(_ key: K) where K.Value == V, K.Value: RawRepresentable, K.Value.RawValue == String {
        self._value = AppStorage(wrappedValue: key.default, key.key)
    }

    // MARK: - 枚举支持（RawRepresentable: Int）

    init<K: AppValueKey>(_ key: K) where K.Value == V, K.Value: RawRepresentable, K.Value.RawValue == Int {
        self._value = AppStorage(wrappedValue: key.default, key.key)
    }
}

public extension AppValue {
    init(_ key: String, value: V) where V == String {
        self._value = AppStorage(wrappedValue: value, key)
    }

    init(_ key: String, value: V) where V == Bool {
        self._value = AppStorage(wrappedValue: value, key)
    }

    init(_ key: String, value: V) where V == Int {
        self._value = AppStorage(wrappedValue: value, key)
    }

    init(_ key: String, value: V) where V == Double {
        self._value = AppStorage(wrappedValue: value, key)
    }

    init(_ key: String, value: V) where V == Data {
        self._value = AppStorage(wrappedValue: value, key)
    }

    init(_ key: String, value: V) where V == URL {
        self._value = AppStorage(wrappedValue: value, key)
    }

    // MARK: - 枚举支持（RawRepresentable: String）

    init(_ key: String, value: V) where V: RawRepresentable, V.RawValue == String {
        self._value = AppStorage(wrappedValue: value, key)
    }

    // MARK: - 枚举支持（RawRepresentable: Int）

    init(_ key: String, value: V) where V: RawRepresentable, V.RawValue == Int {
        self._value = AppStorage(wrappedValue: value, key)
    }
}
