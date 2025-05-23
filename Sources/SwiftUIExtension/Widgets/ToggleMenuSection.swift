//
//  SwiftUIView.swift
//  
//
//  Created by Jo on 2023/12/12.
//

import SwiftUI


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

public struct ToggleMenuItem: View {
    let title: LocalizedStringKey
    let isOn: Bool
    let action: () -> Void
    let image: Image?
    
    public init(_ title: LocalizedStringKey, isOn: Bool, action: @escaping () -> Void) {
        self.title = title
        self.isOn = isOn
        self.action = action
        self.image = nil
    }
    
    public init(_ title: LocalizedStringKey, image: Image, isOn: Bool, action: @escaping () -> Void) {
        self.title = title
        self.isOn = isOn
        self.action = action
        self.image = image
    }
    
    public init(_ title: LocalizedStringKey, systemImageName: String, isOn: Bool, action: @escaping () -> Void) {
        self.init(title, image: Image(systemName: systemImageName), isOn: isOn, action: action)
    }
    
    public init(_ title: LocalizedStringKey, imageName: String, isOn: Bool, action: @escaping () -> Void) {
        self.init(title, image: Image(imageName), isOn: isOn, action: action)
    }
    
    public var body: some View {
        if isOn {
            Toggle(isOn: .constant(true)) {
                makeLabel()
            }
        } else {
            Button(action: action) {
                makeLabel()
            }
        }
    }
    
    @ViewBuilder
    private func makeLabel() -> some View {
        if let image {
            HStack {
                image
                
                Text(title)
            }
        } else {
            Text(title)
        }
    }
}

private extension ToggleMenuSection {
    @ViewBuilder
    func makeMenuItem(_ content: C) -> some View {
        Toggle(isOn: Binding(get: {
            content == value
        }, set: { newValue, _ in
            if newValue {
                value = content
            }
        })) {
            content.makeDisplayLabel()
        }
    }
}

#if DEBUG

struct ToggleMenuSection_Previews: PreviewProvider {
    
    static var previews: some View {
        ToggleMenuSectionPreview()
            .previewDisplayName("ToggleMenuSection 示例")
    }
    
    private struct ToggleMenuSectionPreview: View {
        enum Animal: String, Identifiable, ToggleMenuContent {
            case hare
            case ant
            case ladybug
            case tortoise
            
            var id: String { rawValue }

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

        enum Weather: String, Identifiable, ToggleMenuContent, CaseIterable {
            case sun = "sun.max"
            case rain = "cloud.rain"
            case boltRain = "cloud.bolt.rain"
            case wind = "wind"

            var id: String { rawValue }
            
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
        @State var direction: Bool = false
        @State var score: Int = 0

        var body: some View {
            VStack(alignment: .leading) {
                Text("Selected Animal: \(animal.label)")

                Text("Selected Weather: \(weather.label)")
                
                Menu("Test Menu") {
                    ToggleMenuSection("Chooice Animal", value: $animal)

                    ToggleMenuSection("Chooice Weather", value: $weather)
                    
                    Divider()

                    Toggle("Are you ready", isOn: $isReady)

                    Divider()

                    Button("Add new fruit") {
                        print("Add new fruit")
                    }

                    Button("Do something") {
                        print("Do something")
                    }
                    
                    Divider()
                    
                    ToggleMenuItem("up to down", systemImageName: "arrow.up", isOn: direction) {
                        direction = true
                    }
                    
                    ToggleMenuItem("down to up", systemImageName: "arrow.down", isOn: !direction) {
                        direction = false
                    }
                    
                    Divider()
                    
                    ForEach(0..<6) { sc in
                        ToggleMenuItem("Score \(sc)", isOn: score == sc) {
                            score = sc
                        }
                    }
                }
                
                Spacer()
            }
            .padding(.all, 20)
        }
    }
}

#endif

