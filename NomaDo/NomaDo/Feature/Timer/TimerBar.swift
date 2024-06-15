//
//  TimerBar.swift
//  NomaDo
//
//  Created by Seo-Jooyoung on 6/15/24.
//

import SwiftUI
 
struct TimerBar: View {
    @Binding var downloadAmount: Double
 
    var body: some View {
        VStack {
            ProgressView("", value: downloadAmount, total: 60.0)
                .progressViewStyle(BarProgressStyle(height: 4)) // 스타일 적용
                .padding(.horizontal, 16)
        }
    }
}
 
struct BarProgressStyle: ProgressViewStyle {
    var color: Color = .main
    var height: Double = 4.0
    var labelFontStyle: Font = .body
 
    func makeBody(configuration: Configuration) -> some View {
 
        let progress = configuration.fractionCompleted ?? 0.0
 
        GeometryReader { geometry in
 
            VStack(alignment: .leading) {
                configuration.label
                    .font(labelFontStyle)
 
                RoundedRectangle(cornerRadius: 30.0)
                    .fill(.secondary)
                    .frame(height: height)
                    .frame(width: geometry.size.width)
                    .overlay(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 30.0)
                            .fill(color)
                            .frame(height:height)
                            .frame(width: geometry.size.width * progress)
                            .overlay {
                                if let currentValueLabel = configuration.currentValueLabel {
 
                                    currentValueLabel
                                        .font(.headline)
                                        .foregroundColor(.white)
                                }
                            }
                    }
 
            }
 
        }.frame(height:20)
    }
}
