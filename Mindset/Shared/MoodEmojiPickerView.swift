//
//  MoodEmojiPickerView.swift
//  Mindset
//
//  Created by patrick ridd on 7/6/25.
//

import SwiftUI

struct MoodEmojiPickerView: View {
    let emojis = ["😭", "😞", "🙁", "😐", "🙂", "😀", "🤩"]
    @Binding var selectedIndex: Int?
    @State private var pulse = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("How are you feeling today?")
                .padding(.leading, 8)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: 8) {
                    ForEach(emojis.indices, id: \.self) { idx in
                        Text(emojis[idx])
                            .font(.system(size: 34))
                            .opacity(selectedIndex == idx ? 1.0 : 0.5)
                            .scaleEffect(selectedIndex == nil ? (pulse ? 1.15 : 0.85) : (selectedIndex == idx ? 1.3 : 1.0))
                            .onTapGesture {
                                selectedIndex = idx
                            }
                            .animation(.spring(response: 0.4), value: selectedIndex)
                    }
                }
            }
        }
        .onAppear {
            withAnimation(Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                pulse.toggle()
            }
        }
    }
}

#Preview {
    MoodEmojiPickerView(selectedIndex: .constant(3))
}
