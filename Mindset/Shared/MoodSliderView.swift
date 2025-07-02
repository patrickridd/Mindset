//
//  MoodSliderView.swift
//  Mindset
//
//  Created by patrick ridd on 6/30/25.
//

import SwiftUI

struct MoodSliderView: View {

    @State private var animate = false
    @State private var hasInteracted: Bool = false
    @Binding var moodValue: Double

    let emojiMap = [0: "😭", 1:"😞", 2: "🙁", 3: "😐", 4: "🙂", 5: "😀", 6: "🤩"]
    
    var moodEmoji: String {
        emojiMap[Int(moodValue)] ?? "🙂"
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("How are you feeling today?")
                    .font(.subheadline)
                Text(moodEmoji)
                    .font(.title)
            }
            Slider(value: $moodValue, in: 0...Double(emojiMap.count-1), step: 1)
                .accentColor(.indigo)
                .sensoryFeedback(.selection, trigger: moodValue)
                .shadow(color: Color.orange.opacity(0.7), radius: animate ? 14 : 0)
                .scaleEffect(animate ? 1.1 : 1)
                .animation(animate ? .easeInOut(duration: 1).repeatForever(autoreverses: true) : .default,
                    value: animate
                )
                .onAppear {
                    animate = !hasInteracted
                }
                .onChange(of: moodValue) { _, _ in
                    animate = false
                    hasInteracted = true
                }
        }
        .padding(.horizontal, 24)
    }
}

#Preview {
    MoodSliderView(moodValue: .constant(3))
}

