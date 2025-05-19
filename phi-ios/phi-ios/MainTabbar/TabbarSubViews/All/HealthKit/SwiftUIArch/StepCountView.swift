//
//  StepCountView.swift
//  phi-ios
//
//  Created by Kenneth Wu on 2024/10/24.
//

import SwiftUI

struct StepCountView: View {
    @ObservedObject var viewModel = HealthDataViewModel()
    
    var body: some View {
        VStack {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage).foregroundColor(.red)
            } else {
                List(viewModel.stepCountData, id: \.uuid) { sample in
                    Text("Steps: \(sample.quantity.doubleValue(for: .count()))")
                }
            }
        }
        .onAppear {
            viewModel.requestHealthKitAuthorization()
            let startDate = Calendar.current.startOfDay(for: Date())
            let endDate = Date()
            viewModel.fetchStepCount(startDate: startDate, endDate: endDate)
        }
    }
}

#Preview {
    StepCountView()
}
