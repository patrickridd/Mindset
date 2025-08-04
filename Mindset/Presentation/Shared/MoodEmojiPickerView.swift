//
//  MoodEmojiPickerView.swift
//  Mindset
//
//  Created by patrick ridd on 7/6/25.
//

import SwiftUI

enum Mood: String, CaseIterable {
    case depressed
    case sad
    case bad
    case neutral
    case good
    case happy
    case amazing
    
    static var allCases: [Mood] {
        [.depressed, .sad, .bad, .neutral, .good, .happy, .amazing]
    }

    var emoji: String {
        switch self {
        case .amazing:
            return "🤩"
        case .bad:
            return "🙁"
        case .sad:
            return "😭"
        case .neutral:
            return "😐"
        case .happy:
            return "😀"
        case .depressed:
            return "😞"
        case .good:
            return "🙂"
        }
    }

    var title: String {
        switch self {
        case .bad:
            return "Bad"
        case .sad:
            return "Sad"
        case .neutral:
            return "Okay"
        case .happy:
            return "Happy"
        case .depressed:
            return "Depressed"
        case .good:
            return "Good"
        case .amazing:
            return "Amazing"
        }
    }
}

struct MoodEmojiPickerView: View {
    
    @State private var pulse = false
    @Binding var selectedIndex: Int?

    let emojis = ["😭", "😞", "🙁", "😐", "🙂", "😀", "🤩"]

    var body: some View {
        GroupBox(content: {
            GroupBox {
                HStack(alignment: .center, spacing: 12) {
                    ForEach(Mood.allCases.indices, id: \.self) { index in
                        Text(Mood.allCases[index].emoji)
                            .font(.title)
                            .opacity(selectedIndex == nil ? 1.0 : (selectedIndex == index ? 1.0 : 0.85))
                            .scaleEffect(selectedIndex == nil ? (pulse ? 1.15 : 0.85) : (selectedIndex == index ? 1.5 : 0.85))
                            .onTapGesture {
                                selectedIndex = index
                            }
                            .animation(.spring(response: 0.4), value: selectedIndex)
                    }
                }
                .onAppear {
                    withAnimation(Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                        pulse.toggle()
                    }
                }
            }
        }, label: {
            Label("How Are you feeling today?", systemImage: "sunrise.fill")
        })
        .padding(12)
    }
}

#Preview {
    MoodEmojiPickerView(selectedIndex: .constant(3))
}
