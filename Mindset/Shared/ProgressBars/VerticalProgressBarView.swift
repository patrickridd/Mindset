//
//  VerticalProgressBarView.swift
//  Mindset
//
//  Created by patrick ridd on 7/7/25.
//

import SwiftUI

enum ProgressStatus {
    case notStarted
    case inProgress
    case completed
}

struct TodoCardItem {
    let view: AnyView
    let progressStatus: ProgressStatus
}

struct VerticalProgressBarView: View {
    
    @State var contentHeights: [CGFloat]

    private let todoCardItems: [TodoCardItem]
    private let currentStep: Int
    
    func getProgressImage(todoItem: TodoCardItem) -> String {
        switch todoItem.progressStatus {
        case .notStarted:
            return "circle.dashed"
        case .inProgress:
            return "circle.fill"
        case .completed:
            return "checkmark.circle.fill"
        }
    }

    func getProgressBarLineColor(index: Int) -> Color {
        guard index >= 0 || index > todoCardItems.count-1 else {
            return .gray
        }
        if todoCardItems[index].progressStatus == .completed {
            return .indigo
        } else {
            return .gray
        }
    }

    func getProgressImageColor(index: Int) -> Color {
        if todoCardItems[index].progressStatus == .completed {
            return .green
        }
        if index > currentStep {
            return .gray
        } else {
            return .indigo
        }
    }

    init(todoCardItems: [TodoCardItem], currentStep: Int) {
        self.todoCardItems = todoCardItems
        self.currentStep = currentStep
        _contentHeights = .init(initialValue: Array(repeating: 0, count: todoCardItems.count))
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0
            ) {
                ForEach(0..<todoCardItems.count, id: \.self) { index in
                    CustomRowView(
                        content: todoCardItems[index].view,
                        image: getProgressImage(todoItem: todoCardItems[index]),
                        imageColor: getProgressImageColor(index: index),
                        topLineColor: getProgressBarLineColor(index: index-1),
                        bottomLineColor: getProgressBarLineColor(index: index),
                        index: index,
                        isFirst: index == 0,
                        isLast: index == todoCardItems.count-1
                    )
                }
            }
        }
    }
}

private extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

struct CustomRowView: View {
    let content: AnyView
    let image: String
    let imageColor: Color
    let topLineColor: Color
    let bottomLineColor: Color
    let index: Int
    let isFirst: Bool
    let isLast: Bool
    
    init(content: AnyView, image: String, imageColor: Color, topLineColor: Color, bottomLineColor: Color, index: Int, isFirst: Bool, isLast: Bool) {
        self.content = content
        self.image = image
        self.imageColor = imageColor
        self.topLineColor = topLineColor
        self.bottomLineColor = bottomLineColor
        self.index = index
        self.isFirst = isFirst
        self.isLast = isLast
    }
    
    var body: some View {
        HStack(spacing: 0) {
            VStack(spacing: 0) {
                // Top line
                Rectangle()
                    .fill(topLineColor)
                    .frame(width: 4)
                    .opacity(isFirst ? 0 : 1)
                    .frame(maxHeight: .infinity)
                    .padding(.bottom, 2)

                // Icon
                Image(systemName: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                    .foregroundStyle(imageColor)
                
                // Bottom line
                Rectangle()
                    .fill(topLineColor)
                    .frame(width: 4)
                    .opacity(isLast ? 0 : 1)
                    .frame(maxHeight: .infinity)
                    .padding(.top, 2)
            }
            VStack {
                content
                Divider()
                    .hidden()
                    .padding(.top)
            }
            Spacer()
        }
        .padding(.leading)
    }
}

// Removed CustomLineShape struct as it's no longer needed

#Preview {
    VerticalProgressBarView(todoCardItems: [
        TodoCardItem(
            view: AnyView(
                MoodEmojiPickerView(
                    selectedIndex: .constant(nil)
                )),
            progressStatus: .inProgress
        ),
        TodoCardItem(
            view: AnyView(
                StartPromptsEntryCardView(
                    viewModel: .init(
                        coordinator: Coordinator(viewFactory: ViewFactory()),
                        promptsEntryManager: PromptsEntryManager(promptsEntryPersistence: PromptsEntryFileStore()),
                        dayTime: .morning,
                        selectedPrompts: DayTime.morning.defaultPrompts
                    )
                )
            ),
            progressStatus: .notStarted
        ),
        TodoCardItem(
            view: AnyView(
                StartPromptsEntryCardView(
                    viewModel: .init(
                        coordinator: Coordinator(viewFactory: ViewFactory()),
                        promptsEntryManager: PromptsEntryManager(promptsEntryPersistence: PromptsEntryFileStore()),
                        dayTime: .night,
                        selectedPrompts: DayTime.night.defaultPrompts
                    )
                )
            ),
            progressStatus: .notStarted
        )
    ], currentStep: 1)
}
