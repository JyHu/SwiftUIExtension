//
//  SwiftUIView.swift
//  
//
//  Created by Jo on 2023/12/12.
//

import SwiftUI


///
///
/// struct TestToggleMenuSection: View {
///
///     enum Animal: String, ToggleMenuContent {
///         case hare
///         case ant
///         case ladybug
///         case tortoise
///
///         var label: String {
///             switch self {
///             case .hare: return "兔子"
///             case .ant: return "蚂蚁"
///             case .ladybug: return "瓢虫"
///             case .tortoise: return "乌龟"
///             }
///         }
///
///         var systemImage: String? {
///             rawValue
///         }
///     }
///
///     enum Weather: String, ToggleMenuContent, CaseIterable {
///         case sun = "sun.max"
///         case rain = "cloud.rain"
///         case boltRain = "cloud.bolt.rain"
///         case wind = "wind"
///
///         var label: String {
///             switch self {
///             case .sun: "晴天"
///             case .rain: "雨天"
///             case .boltRain: "雷阵雨"
///             case .wind: "大风"
///             }
///         }
///
///         var systemImage: String? {
///             rawValue
///         }
///     }
///
///     @State var animal: Animal = .hare
///     @State var weather: Weather = .wind
///     @State var isReady: Bool = false
///
///     var body: some View {
///         VStack {
///             Menu("Test Menu") {
///                 ToggleMenuSection("Chooice Animal", value: $animal)
///
///                 Divider()
///
///                 Section {
///                     let weathers = Weather.allCases
///                     ForEach(0..<weathers.count, id: \.self) { ind in
///                         ToggleMenuItem(title: weathers[ind].label, systemImage: weathers[ind].systemImage, bind: $weather, value: weathers[ind])
///                     }
///                 } header: {
///                     Text("Chooice Weather")
///                 }
///
///                 Divider()
///
///                 Toggle("Are you ready", isOn: $isReady)
///
///                 Divider()
///
///                 Button("Add new fruit") {
///
///                 }
///
///                 Button("Do something") {
///
///                 }
///             }
///
///             Spacer()
///         }
///     }
/// }
///
///
///

public struct ToggleMenuItem<T>: View where T: Equatable {
    
    @State private var isOn: Bool
    @Binding private var bindValue: T
    private let value: T
    private let label: AnyView
    
    public init(title: String, systemImage: String? = nil, bind bindValue: Binding<T>, value: T) {
        _bindValue = bindValue
        _isOn = State(wrappedValue: bindValue.wrappedValue == value)
        self.value = value
        
        if let systemImage {
            self.label = AnyView(Label(title, systemImage: systemImage))
        } else {
            self.label = AnyView(Text(title))
        }
    }
    
    public init(title: String, image: String? = nil, bind bindValue: Binding<T>, value: T) {
        _bindValue = bindValue
        _isOn = State(wrappedValue: bindValue.wrappedValue == value)
        self.value = value
        
        if let image {
            self.label = AnyView(Label(title, image: image))
        } else {
            self.label = AnyView(Text(title))
        }
    }
    
    public init(bind bindValue: Binding<T>, value: T, @ViewBuilder label: () -> some View) {
        _bindValue = bindValue
        _isOn = State(wrappedValue: bindValue.wrappedValue == value)
        self.value = value
        self.label = AnyView(label())
    }
    
    public var body: some View {
        Toggle(isOn: $isOn) {
            self.label
        }
        .onChange(of: isOn) { newValue in
            if newValue && value != bindValue {
                bindValue = value
            } else {
                isOn = value == bindValue
            }
        }
        .onChange(of: bindValue) { newValue in
            isOn = newValue == value
        }
    }
}

public protocol ToggleMenuContent: Equatable, CaseIterable {
    var label: String { get }
    var image: String? { get }
    var systemImage: String? { get }
}

public extension ToggleMenuContent {
    var image: String? { nil }
    var systemImage: String? { nil }
}

public struct ToggleMenuSection<C>: View where C: ToggleMenuContent {
    @Binding private var value: C
    private let sectionHeader: String?
    private let contents: [C]
    
    public init(_ sectionHeader: String? = nil, value: Binding<C>) {
        _value = value
        self.sectionHeader = sectionHeader
        self.contents = Array(C.allCases)
    }
    
    public var body: some View {
        Section {
            ForEach(0..<contents.count, id: \.self) { ind in
                let content = contents[ind]
                
                if let image = content.image {
                    ToggleMenuItem(title: content.label, image: image, bind: $value, value: content)
                } else if let systemImage = content.systemImage {
                    ToggleMenuItem(title: content.label, systemImage: systemImage, bind: $value, value: content)
                } else {
                    ToggleMenuItem(title: content.label, systemImage: nil, bind: $value, value: content)
                }
            }
        } header: {
            if let sectionHeader {
                Text(sectionHeader)
            }
        }
    }
}

#if DEBUG

struct TestToggleMenuSection: View {
    
    enum Animal: String, ToggleMenuContent {
        case hare
        case ant
        case ladybug
        case tortoise
        
        var label: String {
            switch self {
            case .hare: return "兔子"
            case .ant: return "蚂蚁"
            case .ladybug: return "瓢虫"
            case .tortoise: return "乌龟"
            }
        }
        
        var systemImage: String? {
            rawValue
        }
    }
    
    enum Weather: String, ToggleMenuContent, CaseIterable {
        case sun = "sun.max"
        case rain = "cloud.rain"
        case boltRain = "cloud.bolt.rain"
        case wind = "wind"
        
        var label: String {
            switch self {
            case .sun: "晴天"
            case .rain: "雨天"
            case .boltRain: "雷阵雨"
            case .wind: "大风"
            }
        }
    
        var systemImage: String? {
            rawValue
        }
    }
    
    @State var animal: Animal = .hare
    @State var weather: Weather = .wind
    @State var isReady: Bool = false
    
    var body: some View {
        VStack {
            Menu("Test Menu") {
                ToggleMenuSection("Chooice Animal", value: $animal)
                
                Divider()
                
                Section {
                    let weathers = Weather.allCases
                    ForEach(0..<weathers.count, id: \.self) { ind in
                        ToggleMenuItem(title: weathers[ind].label, systemImage: weathers[ind].systemImage, bind: $weather, value: weathers[ind])
                    }
                } header: {
                    Text("Chooice Weather")
                }
                
                Divider()
                
                Toggle("Are you ready", isOn: $isReady)
                
                Divider()
                
                Button("Add new fruit") {
                    
                }
                
                Button("Do something") {
                    
                }
            }
            
            Spacer()
        }
    }
}

#Preview {
    TestToggleMenuSection()
}

#endif

