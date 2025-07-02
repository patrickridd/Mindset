//
//  MoodSliderView.swift
//  Mindset
//
//  Created by patrick ridd on 6/30/25.
//

import SwiftUI

struct MoodSliderView: View {

    @State private var moodValue: Double = 3

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
        }
        .padding(.horizontal, 24)
    }
}

#Preview {
    MoodSliderView()
}
