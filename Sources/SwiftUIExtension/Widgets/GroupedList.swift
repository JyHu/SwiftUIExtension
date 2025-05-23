//
//  GroupedList.swift
//  SwiftUIExtension
//
//  Created by hujinyou on 2025/4/23.
//

import SwiftUI


public struct GroupedList<Content: View>: View {
    @ViewBuilder public let contentBuilder: () -> Content

    public init(@ViewBuilder content: @escaping () -> Content) {
        self.contentBuilder = content
    }
    
    public var body: some View {
#if os(macOS)
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 12) {
                contentBuilder()
            }
            .padding(.all, 8)
            .frame(maxWidth: .infinity)
        }
#else
        List {
            contentBuilder()
        }
        .listStyle(.insetGrouped)
#endif
    }
}

public struct GroupedSection<GroupLabel: View, GroupContent: View>: View {
    @ViewBuilder public let content: () -> GroupContent
    @ViewBuilder public let label: () -> GroupLabel
    
    public var body: some View {
#if os(macOS)
        GroupBox(content: {
            VStack(alignment: .leading) {
                content()
            }
            .frame(maxWidth: .infinity)
        }, label: label)
        .frame(maxWidth: .infinity)
        .debugRandomBackground
#else
        Section(content: content, header: label)
#endif
    }
    
    public init(@ViewBuilder content: @escaping () -> GroupContent) where GroupLabel == EmptyView {
        self.content = content
        self.label = { EmptyView() }
    }
    
    public init(@ViewBuilder content: @escaping () -> GroupContent, @ViewBuilder label: @escaping () -> GroupLabel) {
        self.content = content
        self.label = label
    }
    
    public init(_ title: LocalizedStringKey, @ViewBuilder content: @escaping () -> GroupContent) where GroupLabel == Text {
        self.content = content
        self.label = { Text(title) }
    }
}

public struct GroupedSeparator: View {
    public init() {}
    
    public var body: some View {
#if os(macOS)
        Divider()
#else
        EmptyView()
#endif
    }
}

public struct SeparatedForEach<Data: RandomAccessCollection, Content: View, Separator: View>: View where Data.Element: Identifiable {
    let data: Data
    let content: (Data.Element) -> Content
    let separator: () -> Separator

    public init(_ data: Data, @ViewBuilder content: @escaping (Data.Element) -> Content, @ViewBuilder separator: @escaping () -> Separator) {
        self.data = data
        self.content = content
        self.separator = separator
    }
    
    public init(_ data: Data, @ViewBuilder content: @escaping (Data.Element) -> Content) where Separator == GroupedSeparator {
        self.data = data
        self.content = content
        self.separator = { GroupedSeparator() }
    }

    public var body: some View {
        let first = data.first
        
        ForEach(data) { d in
            if d.id != first?.id {
                separator()
            }
            
            content(d)
        }
    }
}

#if DEBUG

struct GroupedSection_Previews: PreviewProvider {
    static var previews: some View { GroupedSectionPreview() }
    
    private struct GroupedSectionPreview: View {
        var body: some View {
            GroupedList {
                GroupedSection("aa") {
                    Text("hello")
                    GroupedSeparator()
                    Text("world")
                }
                
                GroupedSection {
                    Text("hello")
                    GroupedSeparator()
                    Text("world")
                    
                    GroupedSeparator()
                    
                    SeparatedForEach(0..<100) { ind in
                        Text("Number at \(ind)")
                    }
                } label: {
                    HStack {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                        Spacer()
                        Text("hello")
                    }
                }

            }
            .frame(width: 400)
        }
    }
}

#endif

