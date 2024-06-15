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

public protocol ToggleMenuContent: DisplayLabelProtocol {
    var shortKey: KeyEquivalent? { get }
}

public extension ToggleMenuContent {
    var shortKey: KeyEquivalent? { nil }
}

public struct ToggleMenuSection<C>: View where C: ToggleMenuContent {
    @Binding private var value: C
    private let sectionHeader: String?
    private let contents: [C]
    private let eventModifiers: EventModifiers
    
    public init(_ sectionHeader: String? = nil, value: Binding<C>, eventModifiers: EventModifiers = []) {
        _value = value
        self.sectionHeader = sectionHeader
        self.eventModifiers = eventModifiers
        self.contents = Array(C.allCases)
    }
    
    public var body: some View {
        Section {
            ForEach(0..<contents.count, id: \.self) { ind in
                let content = contents[ind]
                
                if let shortKey = content.shortKey {
                    makeMenuItem(content)
                        .keyboardShortcut(shortKey, modifiers: eventModifiers)
                } else {
                    makeMenuItem(content)
                }
            }
        } header: {
            if let sectionHeader {
                Text(sectionHeader)
            }
        }
    }
}

private extension ToggleMenuSection {
    @ViewBuilder
    func makeMenuItem(_ content: C) -> some View {
        if content == value {
            Toggle(isOn: .constant(true), label: {
                content.makeDisplayLabel()
            })
        } else {
            Button(action: {
                value = content
            }, label: {
                content.makeDisplayLabel()
            })
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
        
        var id: String { rawValue }
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
        
        var id: String { rawValue }
    }
    
    @State var animal: Animal = .hare
    @State var weather: Weather = .wind
    @State var isReady: Bool = false
    
    var body: some View {
        VStack {
            Menu("Test Menu") {
                ToggleMenuSection("Chooice Animal", value: $animal)
                
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

