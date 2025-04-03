//
//  HomeView.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 02/04/2025.
//

import SwiftUI

struct HomeView: View {
    let quote: String
    
    var body: some View {
        VStack {
            Text(quote)
                .font(.system(size: 24, weight: .bold))
                .multilineTextAlignment(.center)
                .padding()
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    HomeView(quote: "Test Quote")
}
