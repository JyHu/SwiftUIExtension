//
//  AppearanceView.swift
//  SwiftUIExtension
//
//  Created by hujinyou on 2025/5/22.
//

import SwiftUI

///
/// 使用的时候，可以在app的入口处设置或者恢复之前选择的外观
///
/// @main
/// struct MyApp: App {
///     var body: some Scene {
///         WindowGroup {
///             ContentView()
///                 .applyAppAppearance()
///         }
///     }
/// }
///
///

public enum APPAppearance: String, CaseIterable, Identifiable {
    case auto
    case light
    case dark

    public var id: String { rawValue }

    public var localizedName: String {
        switch self {
        case .auto: return "Auto"
        case .light: return "Light"
        case .dark: return "Dark"
        }
    }
    
    public var systemImage: String {
        switch self {
        case .auto: "circle.lefthalf.fill"
        case .light: "sun.max"
        case .dark: "moon.stars"
        }
    }

    public static let appearanceKey = "com.auu.appearance"

    /// 是否暗色模式，需传入当前 `ColorScheme`
    public func isDark(current: ColorScheme) -> Bool {
        switch self {
        case .auto: return current == .dark
        case .light: return false
        case .dark: return true
        }
    }
}



public struct AppearanceModifier: ViewModifier {
    @AppStorage(APPAppearance.appearanceKey) var appearance: APPAppearance = .auto

    public func body(content: Content) -> some View {
        switch appearance {
        case .auto:
            content
        case .light:
            content.preferredColorScheme(.light)
        case .dark:
            content.preferredColorScheme(.dark)
        }
    }
}

public extension View {
    func applyAppAppearance() -> some View {
        self.modifier(AppearanceModifier())
    }
}


public struct AppearanceView<T>: View where T: PickerStyle {
    public enum ItemStyle {
        case textOnly
        case symbolOnly
        case textAndSymbol
    }
    
    private let pickerStyle: T
    private let label: LocalizedStringKey?
    
    @AppStorage(APPAppearance.appearanceKey) private var appearance: APPAppearance = .auto
    
    @ViewBuilder private let itemMaker: (APPAppearance) -> AnyView

    public init(label: LocalizedStringKey? = nil, itemStyle: ItemStyle = .textAndSymbol, pickerStyle: T = .segmented) {
        self.label = label
        self.pickerStyle = pickerStyle
        self.itemMaker = { appearance in
            switch itemStyle {
            case .textOnly:
                AnyView(Text(appearance.localizedName))
            case .symbolOnly:
                AnyView(Image(systemName: appearance.systemImage))
            case .textAndSymbol:
                AnyView(HStack(spacing: 5) {
                    Image(systemName: appearance.systemImage)
                    Text(appearance.localizedName)
                })
            }
        }
    }
    
    public init(label: LocalizedStringKey? = nil, pickerStyle: T = .segmented, @ViewBuilder itemMaker: @escaping (APPAppearance) -> some View) {
        self.label = label
        self.pickerStyle = pickerStyle
        self.itemMaker = {
            AnyView(itemMaker($0))
        }
    }

    public var body: some View {
        let picker = Picker(self.label ?? "", selection: $appearance) {
            ForEach(APPAppearance.allCases) { item in
                self.itemMaker(item).tag(item)
            }
        }
        .pickerStyle(self.pickerStyle)
        
        if label == nil {
            picker.labelsHidden()
        } else {
            picker
        }
    }
}

#if DEBUG
struct AppearanceView_Previews: PreviewProvider {
    private struct AppearanceGroup<T>: View where T: View {
        let title: LocalizedStringKey
        @ViewBuilder var content: () -> T
        
        var body: some View {
            VStack(spacing: 0) {
                HStack {
                    Text(title).padding(.leading, 10)
                    Spacer()
                }
                
                VStack {
                    content()
                }
                .padding(.all, 10)
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
    }
    private struct AppearanceViewPreview: View {
        var body: some View {
            ScrollView {
                VStack(spacing: 10) {
                    AppearanceGroup(title: "Symbol only") {
                        AppearanceView(itemStyle: .symbolOnly, pickerStyle: .inline)
                        AppearanceView(itemStyle: .symbolOnly, pickerStyle: .menu)
                        if #available(macOS 14.0, *) {
                            AppearanceView(itemStyle: .symbolOnly, pickerStyle: .palette)
                        }
                        AppearanceView(itemStyle: .symbolOnly, pickerStyle: .radioGroup)
                        AppearanceView(itemStyle: .symbolOnly, pickerStyle: .segmented)
                    }
                    
                    AppearanceGroup(title: "Text Only") {
                        AppearanceView(itemStyle: .textOnly, pickerStyle: .inline)
                        AppearanceView(itemStyle: .textOnly, pickerStyle: .menu)
                        if #available(macOS 14.0, *) {
                            AppearanceView(itemStyle: .textOnly, pickerStyle: .palette)
                        }
                        AppearanceView(itemStyle: .textOnly, pickerStyle: .radioGroup)
                        AppearanceView(itemStyle: .textOnly, pickerStyle: .segmented)
                    }
                    
                    AppearanceGroup(title: "Text And Symbol") {
                        AppearanceView(label: "inline", itemStyle: .textAndSymbol, pickerStyle: .inline)
                        AppearanceView(label: "menu", itemStyle: .textAndSymbol, pickerStyle: .menu)
                        if #available(macOS 14.0, *) {
                            AppearanceView(label: "palette", itemStyle: .textAndSymbol, pickerStyle: .palette)
                        }
                        AppearanceView(label: "radioGroup", itemStyle: .textAndSymbol, pickerStyle: .radioGroup)
                        AppearanceView(label: "segmented", itemStyle: .textAndSymbol, pickerStyle: .segmented)
                    }
                    
                    AppearanceGroup(title: "Custom") {
                        AppearanceView(pickerStyle: .radioGroup) { appearance in
                            HStack {
                                Text(appearance.localizedName)
                                Text("-")
                                Text(appearance.systemImage)
                                
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(appearance._color())
                                    .frame(width: 30, height: 20)
                            }
                        }
                    }
                }
                .padding()
            }
            .frame(height: 500)
        }
    }
    
    static var previews: some View {
        AppearanceViewPreview()
            .applyAppAppearance()
    }
}

private extension APPAppearance {
    func _color() -> Color {
        switch self {
        case .auto: return Color.yellow
        case .light: return Color.white
        case .dark: return Color.black
        }
    }
}

#endif
