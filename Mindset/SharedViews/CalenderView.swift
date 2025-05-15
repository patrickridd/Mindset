//
//  CalenderView.swift
//  Mindset
//
//  Created by patrick ridd on 5/14/25.
//

import SwiftUI

struct CalenderView: View {
    
    var spacing: CGFloat {
        UIScreen.main.bounds.width/9
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            GroupBox {
                Text("MAY")
                    .font(.headline)
            }
            ScrollView(.horizontal) {
                HStack(alignment: .center, spacing: spacing) {
                    ForEach(Array(Week.allCases)) { day in
                        Text(day.abbreviation)
                            .font(.subheadline)
                    }
                }
                .frame(width: UIScreen.main.bounds.width, alignment: .center)
            }
        }
    }
}

#Preview {
    CalenderView()
}
