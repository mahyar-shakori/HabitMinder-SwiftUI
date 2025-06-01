//
//  ProgressCircleView.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 16/04/2025.
//

import SwiftUI

struct ProgressCircleView: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    let progress: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(themeManager.appSecondary, lineWidth: 7)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(themeManager.appPrimary, style: StrokeStyle(lineWidth: 7, lineCap: .round))
                .rotationEffect(.degrees(-90))
        }
        .frame(width: 35, height: 35)
    }
}

#Preview {
    ProgressCircleView(progress: 0.2)
}
