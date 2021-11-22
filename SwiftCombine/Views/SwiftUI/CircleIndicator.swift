//
//  CircleIndicator.swift
//  swiftUIProject
//
//  Created by Yu Li Lin on 2024/7/2.
//

import SwiftUI

struct CircleIndicator: View {
    var animation:Animation = .linear(duration: 1)

    //MARK: - Private Properties
    private let lineWidth = 5.0
    
    @State private var startAngle = 0.0
    @State private var endAngle = 0.25

    @State private var isSpinning: Bool = false
    @State private var degreesRotating = 0.0

    @available(iOS 15.0, *)
    var body: some View {
        ZStack {
            Circle().stroke(lineWidth: lineWidth)
                .foregroundStyle(.tertiary)
                .overlay {
                    Circle().trim(from: startAngle, to: endAngle)
                        .stroke(.blue, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                        .background(Color.clear)
                }.background(Color.clear)
        }
        .background(Color.clear)
        .rotationEffect(.degrees(degreesRotating))
            .onAppear {
                withAnimation(animation
                    .speed(1).repeatForever(autoreverses: false)) {
                        degreesRotating = 360.0
                    }
            }
    }
}

