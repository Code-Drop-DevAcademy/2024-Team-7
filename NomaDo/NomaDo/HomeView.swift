//
//  ContentView.swift
//  NomaDo
//
//  Created by Seo-Jooyoung on 6/15/24.
//

import SwiftUI
import Charts

struct RecordModel: Hashable {
    var id = UUID()
    var date: Date
    var togetherPeople: [Int]
}

struct HomeView: View {

    @State var startTime : Date = Date()
    @State var endTime : Date = Date()
    
    @State var records: [RecordModel] = [
        RecordModel(date: Date().addingTimeInterval(-86400 * 5), togetherPeople: [10, 2, 3]),
        RecordModel(date: Date().addingTimeInterval(-86400 * 4), togetherPeople: [30, 2]),
        RecordModel(date: Date().addingTimeInterval(-86400 * 3), togetherPeople: [50]),
        RecordModel(date: Date().addingTimeInterval(-86400 * 2), togetherPeople: [80, 2, 3, 4]),
        RecordModel(date: Date().addingTimeInterval(-86400 * 1), togetherPeople: [100, 2, 3])
    ]
    
    var body: some View {
        VStack(spacing: 37) {
            // Top
            ZStack {
                Rectangle()
                    .frame(height: 120)
                    .cornerRadius(9)
                    .foregroundColor(.gray0)
                VStack(alignment: .leading) {
                    Text("다음 스트레칭까지")
                        .font(.custom(AppFont.semiBold, size: 18))
                        .foregroundColor(.white)
                        .padding(.horizontal, 5)
                        .padding(.top, 5)
                    HStack {
                        Text("45:03")
                            .font(.custom(AppFont.semiBold, size: 52))
                            .foregroundColor(.main)
                        Spacer()
                        Button {
                            
                        } label: {
                            ZStack {
                                Rectangle()
                                    .frame(width: 106, height: 41)
                                    .cornerRadius(9)
                                    .foregroundColor(.gray1)
                                Text("참여하기")
                                    .font(.custom(AppFont.medium, size: 17))
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
            }
            
            // Center
            
            VStack {
                HStack{
                    Text("함께 한 노마드")
                        .font(.custom(AppFont.semiBold, size: 17))
                        .foregroundColor(.white) // TODO: - white로 변경
                    Spacer()
                }
                Chart {
                    ForEach(records, id: \.self) { record in
                        LineMark(
                            x: .value("Day", record.date),
                            y: .value("Sales", record.togetherPeople[0])
                        )
                        .foregroundStyle(.main)
                    }
                }
                .frame(height: 327)
                .background(Color.gray0)
            }
            
            // Bottom
            VStack(spacing: 8) {
                Toggle(isOn: .constant(true), label: {
                    Text("시간")
                        .font(.custom(AppFont.semiBold, size: 17))
                })
                
                TimeList(startTime: $startTime, endTime: $endTime)
            }
        }
        .padding(.horizontal, 16)
    }
    
}

fileprivate struct TimeList: View {
    @Binding var startTime: Date
    @Binding var endTime: Date
    var body: some View {
        VStack(spacing: 2) {
            ZStack {
                Rectangle()
                    .frame(height: 53)
                    .cornerRadius(13)
                    .foregroundColor(.gray0)
                HStack {
                    Text("시작 시간")
                    Spacer()
                    DatePicker("", selection: Binding(
                        get: { roundToHour(startTime) },
                        set: { startTime = roundToHour($0) }
                    ), displayedComponents: .hourAndMinute)
                    .datePickerStyle(.compact)
                    .labelsHidden()
                }
                .padding(.horizontal, 16)
            }
            ZStack {
                Rectangle()
                    .frame(height: 53)
                    .cornerRadius(13)
                    .foregroundColor(.gray0)
                HStack {
                    Text("종료 시간")
                    Spacer()
                    DatePicker("", selection: $endTime, displayedComponents: .hourAndMinute)
                        .datePickerStyle(.compact)
                        .labelsHidden()
                }
                .padding(.horizontal, 16)
            }
        }
    }
    
    func roundToHour(_ date: Date) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour], from: date)
        return calendar.date(from: components) ?? date
    }
}

#Preview{
    HomeView(startTime: Date())
}
