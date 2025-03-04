//
//  CellModifier.swift
//  SwiftCombine
//
//  Created by Yu Li Lin on 2025/3/4.
//

import SwiftUI

struct CellModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .listRowBackground(Color.red)
            .listRowInsets(EdgeInsets(top: 10, leading: 10, bottom: 20, trailing: 10))
    }
}
