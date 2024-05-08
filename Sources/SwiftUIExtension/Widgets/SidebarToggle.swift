//
//  SwiftUIView.swift
//  
//
//  Created by Jo on 2023/12/12.
//

import SwiftUI


#if os(macOS)

public struct SidebarToggle: View {
    
    private let title: String?
    private let systemImage: String?
    
    public init(title: String? = nil, systemImage: String? = nil) {
        self.title = title
        self.systemImage = systemImage
    }
    
    public var body: some View {
        Button {
            NSApp.sendAction(#selector(NSSplitViewController.toggleSidebar(_:)), to: nil, from: nil)
        } label: {
            if let systemImage {
                if let title = title {
                    Label(title, systemImage: systemImage)
                } else {
                    Image(systemName: systemImage)
                }
            } else if let title = title {
                Text(title)
            } else {
                Image(systemName: "sidebar.left")
                    .help("Toggle Sidebar")
            }
        }

    }
}

struct SidebarToggle_Previews: PreviewProvider {
    static var previews: some View {
        SidebarToggle()
    }
}

#endif
