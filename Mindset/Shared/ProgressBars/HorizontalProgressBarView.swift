//
//  ProgressBarView.swift
//  Mindset
//
//  Created by patrick ridd on 6/2/25.
//

import SwiftUI

import SwiftUI

struct HorizontalProgressBarView: View {
    var progress: Double // 0.0 to 1.0
    var gradient: LinearGradient = LinearGradient(
        gradient: Gradient(colors: [Color.pink, Color.blue]),
        startPoint: .leading,
        endPoint: .trailing
    )

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background bar
                RoundedRectangle(cornerRadius: 8)
                    .frame(height: 8)
                    .foregroundColor(Color.gray.opacity(0.2))
                // Progress bar
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: CGFloat(progress) * geometry.size.width, height: 8)
                    .foregroundStyle(gradient)
                    .animation(.easeInOut, value: progress)
            }
        }
        .frame(height: 8)
        .padding(.horizontal, 32)
    }
}

#Preview {
    HorizontalProgressBarView(progress: 0.6)
}
