//
//  PulsingIcon.swift
//  Mindset
//
//  Created by patrick ridd on 7/30/25.
//

import SwiftUI

struct PulsingIcon: View {
    @State private var pulse = false

    let systemName: String
    let foregroundColor: Color
    let borderColor: Color
    let isInProgress: Bool
    let imageSize: CGFloat

    var body: some View {
        Image(systemName: systemName)
            .resizable()
            .frame(width: imageSize, height: imageSize)
            .aspectRatio(contentMode: .fill)
            .foregroundStyle(foregroundColor)
            .clipShape(Circle())
            .overlay(
                Circle().stroke(borderColor, lineWidth: 2)
            )
            .scaleEffect(isInProgress && pulse ? 0.8 : 1.0)
            .animation(
                isInProgress ? Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true) : .default,
                value: pulse
            )
            .id(isInProgress)
            .onAppear {
                if isInProgress {
                    pulse = true
                }
            }
            .onChange(of: isInProgress) { oldValue, newValue in
                if newValue {
                    pulse = true
                } else {
                    pulse = false
                }
            }
            .onDisappear {
                pulse = false
            }
    }
}

#Preview {
    PulsingIcon(systemName: "circle", foregroundColor: .indigo, borderColor: .clear, isInProgress: false, imageSize: 24)
}
