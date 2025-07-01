//
//  MoodSliderView.swift
//  Mindset
//
//  Created by patrick ridd on 6/30/25.
//

import SwiftUI

struct MoodSliderView: View {

    @State private var moodValue: Double = 5

    let emojiMap = [
        0: "😭", 1: "😢", 2: "😞", 3: "🙁", 4: "🫤", 5: "😐",
        6: "🙂", 7: "😊", 8: "😄", 9: "😁", 10: "🤩"
    ]
    
    var moodEmoji: String {
        emojiMap[Int(moodValue)] ?? "🙂"
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("How are you feeling today? \(moodEmoji)")
                .font(.title2)
            Slider(value: $moodValue, in: 0...10, step: 1)
                .accentColor(.indigo)
                .sensoryFeedback(.selection, trigger: moodValue)
            Text("\(Int(moodValue))/10")
                .font(.headline)
        }
        .padding(.horizontal, 24)
    }
}

#Preview {
    MoodSliderView()
}
