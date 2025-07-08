//
//  VerticalProgressBarView.swift
//  Mindset
//
//  Created by patrick ridd on 7/7/25.
//

import SwiftUI

struct VerticalProgressBarView: View {
    
    @State var contentHeights: [CGFloat]
    
    private let views: [AnyView]
    private let currentStep: Int

    init(views: [any View], currentStep: Int) {
        self.views = views.map { AnyView($0) }
        self.currentStep = currentStep
        _contentHeights = .init(initialValue: Array(repeating: 0, count: views.count))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                ForEach(0..<views.count, id: \.self) { index in
                    HStack(alignment: .center, spacing: 0) {
                        ZStack(alignment: .top) {
                            Circle()
                                .fill(index <= currentStep ? .indigo : .gray.opacity(0.5))
                                .frame(width: 18, height: 18)
                            if index < views.count - 1 {
                                Rectangle()
                                    .fill(index < currentStep ? .indigo : .gray.opacity(0.5))
                                    .frame(width: 4,
                                           height: max(24, (contentHeights[safe: index + 1] ?? 0) / 2
                                                       + (contentHeights[safe: index] ?? 0) / 2)
                                    )
                                    .offset(y: 18)
                                    .animation(.easeInOut(duration: 0.3), value: contentHeights[safe: index + 1] ?? 0)
                            }
                        }
                        .padding(.leading)
                        GeometryReader { _ in
                            views[index]
                                .background(
                                    GeometryReader { innerGeo in
                                        Color.clear
                                            .onAppear {
                                                contentHeights[index] = innerGeo.size.height
                                            }
                                            .onChange(of: innerGeo.size.height) { _, newValue in
                                                contentHeights[index] = newValue
                                            }
                                    }
                                )
                        }
                        .frame(minHeight: 24)
                    }
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

#Preview {
    VerticalProgressBarView(views: [
        StartPromptsEntryCardView(viewModel: .init(coordinator: Coordinator(viewFactory: ViewFactory()), promptsEntryManager: PromptsEntryManager(promptsEntryPersistence: PromptsEntryFileStore()), dayTime: .morning, selectedPrompts: DayTime.morning.defaultPrompts)),
        StartPromptsEntryCardView(viewModel: .init(coordinator: Coordinator(viewFactory: ViewFactory()), promptsEntryManager: PromptsEntryManager(promptsEntryPersistence: PromptsEntryFileStore()), dayTime: .night, selectedPrompts: DayTime.night.defaultPrompts))
    ], currentStep: 0)
}
