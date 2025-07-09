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
        let nextIndex = index + 1
        
        // Return early if nextIndex is out of range
        guard nextIndex < todoCardItems.count else {
            return .clear
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
            VStack(spacing: 12) {
                ForEach(0..<todoCardItems.count, id: \.self) { index in
                    CustomRowView(
                        content: todoCardItems[index].view,
                        image: getProgressImage(todoItem: todoCardItems[index]),
                        imageColor: getProgressImageColor(index: index),
                        lineColor: getProgressBarLineColor(index: index),
                        startX: 20,
                        rightPadding: 20,
                        position: index < todoCardItems.count - 1 ? .start : .end
                    )
                }
            }
        }

//        ScrollView {
//            VStack(alignment: .leading, spacing: 20) {
//                ForEach(0..<todoCardItems.count, id: \.self) { index in
//                    HStack(alignment: .center, spacing: 0) {
//                        GeometryReader { _ in
//                            todoCardItems[index].view
//                                .background(
//                                    GeometryReader { innerGeo in
//                                        Color.clear
//                                            .onAppear {
//                                                contentHeights[index] = innerGeo.size.height
//                                            }
//                                            .onChange(of: innerGeo.size.height) { _, newValue in
//                                                contentHeights[index] = newValue
//                                            }
//                                    }
//                                )
//                        }
//                        .frame(minHeight: 24)
//                        ZStack(alignment: .top) {
//                            Circle()
//                                .fill(index <= currentStep ? .indigo : .gray.opacity(0.5))
//                                .frame(width: 18, height: 18)
//                            if index < todoCardItems.count - 1 {
//                                Rectangle()
//                                    .fill(index < currentStep ? .indigo : .gray.opacity(0.5))
//                                    .frame(width: 4,
//                                           height: max(24, (contentHeights[safe: index + 1] ?? 0) / 2
//                                                       + (contentHeights[safe: index] ?? 0) / 2)
//                                    )
//                                    .offset(y: 18)
//                                    .animation(.easeInOut(duration: 0.3), value: contentHeights[safe: index + 1] ?? 0)
//                            }
//                        }
//                        .padding(.leading)
//                    }
//                }
//            }
//        }
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
    let startX: CGFloat
    let rightPadding: CGFloat
    let imageColor: Color
    let lineColor: Color
    let position: CustomLineShape.Position

    init(content: AnyView, image: String, imageColor: Color, lineColor: Color, startX: CGFloat, rightPadding: CGFloat, position: CustomLineShape.Position) {
        self.content = content
        self.image = image
        self.startX = startX
        self.rightPadding = rightPadding
        self.imageColor = imageColor
        self.lineColor = lineColor
        self.position = position
    }
    
    var body: some View {
        HStack(spacing: -20) {
            ZStack(alignment: .center) {
                CustomLineShape(startX: startX)
                    .stroke(style: StrokeStyle(lineWidth: position == .start ? 4 : 0, lineCap: .round))
                    .foregroundColor(lineColor)
                Image(systemName: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                    .foregroundStyle(imageColor)
                    .padding(position == .start ? .top : .bottom, 20)
            }
            .frame(width: startX + rightPadding)
            content
            Spacer()
        }
        .padding(.trailing)
    }
}

struct CustomLineShape: Shape {
    let startX: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: startX, y: startX + rect.midY + 2))
        path.addLine(to: CGPoint(x: startX, y: 1.5 * rect.maxY - 23))
        return path
    }
    
    enum Position {
        case start
        case end
    }
}

#Preview {
    VerticalProgressBarView(todoCardItems: [
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
            progressStatus: .completed
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
            progressStatus: .inProgress
        )
    ], currentStep: 1)
}
