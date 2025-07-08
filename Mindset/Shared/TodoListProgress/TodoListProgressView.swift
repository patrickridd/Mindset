//  TodoListProgressView.swift
//  Mindset
//  Created to match the vertical todo progress bar UI example.

import SwiftUI

protocol TodoItem: Identifiable {
    var id: UUID { get }
    var title: String { get }
    var subtitle: String? { get }
    var imageName: String { get }
    var gradient: LinearGradient { get }
    var completed: Bool { get set }
}

struct TodoCardItem: TodoItem {
    let id = UUID()
    let title: String
    let subtitle: String?
    var imageName: String
    let gradient: LinearGradient
    var completed: Bool = false
}

struct TodoCardView: View {
    let todo: any TodoItem

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            todo.gradient
                .cornerRadius(28)
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(todo.title)
                        .font(.title2.bold())
                        .foregroundStyle(.white)
                        .lineLimit(2)
                    HStack {
                        Image(systemName: "clock")
                            .foregroundStyle(.white.opacity(0.7))
                        if let subtitle = todo.subtitle {
                            Text(subtitle)
                                .foregroundStyle(.white.opacity(0.7))
                        }
                    }
                    .font(.subheadline)
                }
                Spacer()
                // Replace "photo" with your image asset name
                Image(todo.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 90, height: 90)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .padding()
        }
        .frame(height: 130)
        .padding(.horizontal)
    }
}

//struct TodoListProgressView: View {
//    let todos: [TodoCardItem]
//    var currentStep: Int
//
//    var body: some View {
//        HStack(alignment: .top, spacing: 0) {
//            VerticalProgressBarView(stepCount: todos.count, currentStep: currentStep)
//                .padding(.leading, 12)
//            VStack(spacing: 24) {
//                ForEach(Array(todos.enumerated()), id: \.element.id) { index, todo in
//                    TodoCardView(todo: todo)
////                        .onTapGesture {
////                            currentStep = index
////                        }
//                }
//            }
//            .padding(.vertical)
//        }
//        .background(Color.black.ignoresSafeArea())
//    }
//}

//#Preview {
//    TodoListProgressView(todos: [
//        TodoCardItem(
//            title: "How are you feeling today",
//            subtitle: "",
//            imageName: "photo", // Replace with your asset
//            gradient: LinearGradient(colors: [Color.orange, Color.purple], startPoint: .topLeading, endPoint: .bottomTrailing)
//        ),
//        TodoCardItem(
//            title: "Morning Mindset",
//            subtitle: "3 min",
//            imageName: "photo", // Replace with your asset
//            gradient: LinearGradient(colors: [Color.blue, Color.orange], startPoint: .topLeading, endPoint: .bottomTrailing)
//        ),
//        TodoCardItem(
//            title: "Sleep Mindset",
//            subtitle: "3 min",
//            imageName: "photo", // Replace with your asset
//            gradient: LinearGradient(colors: [Color.purple, Color.blue], startPoint: .topLeading, endPoint: .bottomTrailing)
//        )
//    ], currentStep: 2)
//}
