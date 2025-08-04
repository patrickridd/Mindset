//
//  VerticalProgressBarView.swift
//  Mindset
//
//  Created by patrick ridd on 7/7/25.
//

import SwiftUI

enum ProgressStatus {
    case locked
    case inProgress
    case completed
}

struct TodoCardItem {
    let view: AnyView
    let progressStatus: ProgressStatus
}

struct VerticalProgressBarView: View {

    var currentStep: Int
    var todoCardItems: [TodoCardItem]

    init(todoCardItems: [TodoCardItem], currentStep: Int) {
        self.todoCardItems = todoCardItems
        self.currentStep = currentStep
    }

    func isFirst(index: Int) -> Bool {
        index == 0
    }

    func isLast(index: Int) -> Bool {
        index == todoCardItems.count - 1
    }

    func getProgressImage(todoItem: TodoCardItem) -> String {
        switch todoItem.progressStatus {
        case .locked:
            return "circle.dashed"
        case .inProgress:
            return "circle.fill"
        case .completed:
            return "checkmark.square.fill"
        }
    }

    func getTopBarLineColor(index: Int) -> Color {
        if isFirst(index: index) { return .clear }
        
        switch todoCardItems[index-1].progressStatus {
        case .locked, .inProgress:
            return .gray
        case .completed:
            return .indigo
        }
    }

    func getBottomBarLineColor(index: Int) -> Color {
        if isLast(index: index) {
            return .clear
        }
        switch todoCardItems[index].progressStatus {
        case .locked, .inProgress:
            return .gray
        case .completed:
            return .indigo
        }
    }

    func getProgressImageColor(todoItem: TodoCardItem) -> Color {
        switch todoItem.progressStatus {
        case .locked:
            return .gray
        case .inProgress:
            return .indigo
        case .completed:
            return .green
        }
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                ForEach(0..<todoCardItems.count, id: \.self) { index in
                    CustomRowView(
                        content: todoCardItems[index].view,
                        image: getProgressImage(todoItem: todoCardItems[index]),
                        imageColor: getProgressImageColor(todoItem: todoCardItems[index]),
                        topLineColor: getTopBarLineColor(index: index),
                        bottomLineColor: getBottomBarLineColor(index: index),
                        index: index,
                        isFirst: isFirst(index: index),
                        isLast: isLast(index: index),
                        progressStatus: todoCardItems[index].progressStatus,
                        isCurrentStep: currentStep == index
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

    @State private var pulse: Bool = false
    @State var isCurrentStep: Bool
   
    let content: AnyView
    let image: String
    let imageColor: Color
    let topLineColor: Color
    let bottomLineColor: Color
    let index: Int
    let isFirst: Bool
    let isLast: Bool
    var progressStatus: ProgressStatus
    
    init(content: AnyView, image: String, imageColor: Color, topLineColor: Color, bottomLineColor: Color, index: Int, isFirst: Bool, isLast: Bool, progressStatus: ProgressStatus, isCurrentStep: Bool) {
        self.content = content
        self.image = image
        self.imageColor = imageColor
        self.topLineColor = topLineColor
        self.bottomLineColor = bottomLineColor
        self.index = index
        self.isFirst = isFirst
        self.isLast = isLast
        self.progressStatus = progressStatus
        self.isCurrentStep = isCurrentStep
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
                    .scaleEffect(progressStatus == .inProgress ? (pulse ? 1.15 : 0.85) : 1.0)

                // Bottom line
                Rectangle()
                    .fill(bottomLineColor)
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
        .onAppear {
            withAnimation(Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                pulse = isCurrentStep
            }
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
                MindsetEntryCardView(
                    viewModel: .init(
                        coordinator: Coordinator(viewFactory: ViewFactory()),
                        promptsEntryManager: PromptsEntryManager(promptsEntryPersistence: PromptsEntryFileStore()),
                        dayTime: .morning,
                        promptsEntry: Mocks.morningMindSet,
                        progressStatus: .completed,
                        onDelete: nil
                    )
                )
            ),
            progressStatus: .locked
        ),
        TodoCardItem(
            view: AnyView(
                MindsetEntryCardView(
                    viewModel: .init(
                        coordinator: Coordinator(viewFactory: ViewFactory()),
                        promptsEntryManager: PromptsEntryManager(promptsEntryPersistence: PromptsEntryFileStore()),
                        dayTime: .night,
                        promptsEntry: Mocks.nightMindSet,
                        progressStatus: .inProgress,
                        onDelete: nil
                    )
                )
            ),
            progressStatus: .locked
        )
    ], currentStep: 1)
}
