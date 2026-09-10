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
    func update(_ value: Value?)
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
    
    func update(_ value: Value?) {
        if let value = value {
            UserDefaults.standard.set(value, forKey: key)
            UserDefaults.standard.synchronize()
        } else {
            UserDefaults.standard.removeObject(forKey: key)
        }
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

// MARK: - AppStorageConvertible

/// 标记类型可被 `@AppStorage` 直接存储，用于收敛 `AppValue` 的重复 init。
///
/// 如需扩展支持的基础类型，只需添加新的 conformance 即可。
public protocol AppStorageConvertible {
    static func appStorage(wrappedValue: Self, key: String) -> AppStorage<Self>
}

extension String: AppStorageConvertible {
    public static func appStorage(wrappedValue: Self, key: String) -> AppStorage<Self> {
        AppStorage(wrappedValue: wrappedValue, key)
    }
}

extension Bool: AppStorageConvertible {
    public static func appStorage(wrappedValue: Self, key: String) -> AppStorage<Self> {
        AppStorage(wrappedValue: wrappedValue, key)
    }
}

extension Int: AppStorageConvertible {
    public static func appStorage(wrappedValue: Self, key: String) -> AppStorage<Self> {
        AppStorage(wrappedValue: wrappedValue, key)
    }
}

extension Double: AppStorageConvertible {
    public static func appStorage(wrappedValue: Self, key: String) -> AppStorage<Self> {
        AppStorage(wrappedValue: wrappedValue, key)
    }
}

extension Data: AppStorageConvertible {
    public static func appStorage(wrappedValue: Self, key: String) -> AppStorage<Self> {
        AppStorage(wrappedValue: wrappedValue, key)
    }
}

extension URL: AppStorageConvertible {
    public static func appStorage(wrappedValue: Self, key: String) -> AppStorage<Self> {
        AppStorage(wrappedValue: wrappedValue, key)
    }
}

// MARK: - AppValue

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
/// - `Array`（Element 需遵循 Codable，以 JSON 字符串存储）
/// - `Dictionary`（Key 和 Value 需遵循 Codable，以 JSON 字符串存储）
///
/// ✅ 使用方式：
/// ```swift
/// struct ContentView: View {
///     @AppValue(SIDs.showSidebar) private var showSidebar: Bool
///     @AppValue(SIDs.username) private var username: String
///     @AppValue(SIDs.launchMode) private var mode: LaunchMode
///     @AppValue(SIDs.tags) private var tags: [String]
///     @AppValue(SIDs.settings) private var settings: [String: Int]
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

// MARK: - init with AppValueKey

public extension AppValue {

    /// 基础类型（String, Bool, Int, Double, Data, URL）
    init<K: AppValueKey>(_ key: K) where K.Value == V, V: AppStorageConvertible {
        self._value = V.appStorage(wrappedValue: key.default, key: key.key)
    }

    /// 枚举支持（RawValue 为 String）
    init<K: AppValueKey>(_ key: K) where K.Value == V, V: RawRepresentable, V.RawValue == String {
        self._value = AppStorage(wrappedValue: key.default, key.key)
    }

    /// 枚举支持（RawValue 为 Int）
    init<K: AppValueKey>(_ key: K) where K.Value == V, V: RawRepresentable, V.RawValue == Int {
        self._value = AppStorage(wrappedValue: key.default, key.key)
    }
}

// MARK: - init with String key

public extension AppValue {

    /// 基础类型（String, Bool, Int, Double, Data, URL）
    init(_ key: String, value: V) where V: AppStorageConvertible {
        self._value = V.appStorage(wrappedValue: value, key: key)
    }

    /// 枚举支持（RawValue 为 String）
    init(_ key: String, value: V) where V: RawRepresentable, V.RawValue == String {
        self._value = AppStorage(wrappedValue: value, key)
    }

    /// 枚举支持（RawValue 为 Int）
    init(_ key: String, value: V) where V: RawRepresentable, V.RawValue == Int {
        self._value = AppStorage(wrappedValue: value, key)
    }
}

// MARK: - Array + RawRepresentable (Codable JSON 存储)

extension Array: @retroactive RawRepresentable where Element: Codable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([Element].self, from: data)
        else { return nil }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else { return "[]" }
        return result
    }
}

// MARK: - Dictionary + RawRepresentable (Codable JSON 存储)

extension Dictionary: @retroactive RawRepresentable where Key: Codable, Value: Codable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([Key: Value].self, from: data)
        else { return nil }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else { return "{}" }
        return result
    }
}

// MARK: - Optional + RawRepresentable (Codable 类型以 JSON 字符串存储，支持 Date? 等可选类型)

/// 让 `Optional<Wrapped>`（Wrapped: Codable）可以作为 `@AppStorage` 的存储类型。
///
/// 背景：`@AppStorage` / `@AppValue` 要求存储类型满足 `RawRepresentable & Codable`，
/// 且泛型 RawRepresentable 的 AppStorage 特化只接受 `RawValue == String`（见 AppStorage
/// 的 `init(wrappedValue:key:) where Value.RawValue == String`），因此 `Date?` 这类
/// 无法直接存储的类型，通过把 Optional 包装成 rawValue 为 JSON 字符串的 RawRepresentable，
/// 即可被 @AppStorage 识别。nil → 空字符串，非 nil → JSON 编码。
extension Optional: @retroactive RawRepresentable where Wrapped: Codable {
    public init?(rawValue: String) {
        guard !rawValue.isEmpty,
              let data = rawValue.data(using: .utf8),
              let value = try? JSONDecoder().decode(Wrapped?.self, from: data)
        else { return nil }
        self = value
    }

    public var rawValue: String {
        guard let self,
              let data = try? JSONEncoder().encode(self)
        else { return "" }
        return String(data: data, encoding: .utf8) ?? ""
    }
}
