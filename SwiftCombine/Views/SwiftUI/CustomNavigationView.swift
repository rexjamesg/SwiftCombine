//
//  CustomNavigationView.swift
//  SwiftCombine
//
//  Created by Yu Li Lin on 2025/3/4.
//

import SwiftUI

struct CustomNavigationView<Content: View>: View {
    var title: String
    var popAction: () -> Void
    let content: Content

    init(title: String,
         popAction: @escaping () -> Void,
         @ViewBuilder content: () -> Content) {
        self.title = title
        self.popAction = popAction
        self.content = content()
    }
    
    var body: some View {
        NavigationView {
            content
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: popAction) {
                            HStack {
                                Image(systemName: "chevron.left")
                                Text("返回")
                            }
                        }
                    }
                }
        }
    }
}
