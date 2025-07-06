//
//  DayTimePicker.swift
//  Mindset
//
//  Created by patrick ridd on 7/3/25.
//

import SwiftUI

struct DayTimePicker: View {
    
    @Environment(\.colorScheme) private var colorScheme
    @Binding var dayTime: DayTime
    
    var body: some View {
        HStack(alignment: .center, spacing: 4) {
            ForEach(DayTime.allCases, id: \.self) { type in
                Button(action: {
                    dayTime = type
                }) {
                    Text(type.displayName)
                        .font(.title2)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 18)
                        .background(
                            dayTime == type ? Color.indigo.opacity(colorScheme == .dark ? 0.5 : 0.9) : .gray.opacity(0.4)
                        )
                        .foregroundStyle(dayTime == type ? Color.accentColor : Color.primary)
                        .clipShape(Capsule())
                        .animation(
                            .easeInOut(duration: 0.18),
                            value: dayTime
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .animation(
            .easeInOut(duration: 0.5),
            value: dayTime
        )
    }
}

#Preview {
    DayTimePicker(dayTime: .constant(.morning))
}
