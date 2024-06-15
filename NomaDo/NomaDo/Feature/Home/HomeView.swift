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
    
    let notificationManager = NotificationManager.instance
    
    @State var startTime : Date = Date()
    @State var endTime : Date = Date().addingTimeInterval(8 * 3600)
    
    @State var isNotificationOn : Bool = false
    @State var isShowingSheet : Bool = false
    
    @State var records: [RecordModel] = [
                RecordModel(date: Date().addingTimeInterval(-86400 * 5), togetherPeople: [10, 2, 3]),
                RecordModel(date: Date().addingTimeInterval(-86400 * 4), togetherPeople: [30, 2]),
        RecordModel(date: Date().addingTimeInterval(-86400 * 3), togetherPeople: [50]),
        RecordModel(date: Date().addingTimeInterval(-86400 * 2), togetherPeople: [80, 2, 3, 4]),
        RecordModel(date: Date().addingTimeInterval(-86400 * 1), togetherPeople: [90, 2, 3])
    ]
    
    var body: some View {
        VStack(spacing: 37) {
            // Top
            ZStack {
                Rectangle()
                    .frame(height: 120)
                    .cornerRadius(9)
                    .foregroundStyle(.gray0)
                VStack(alignment: .leading) {
                    Text("다음 스트레칭까지")
                        .font(.custom(AppFont.semiBold, size: 18))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 5)
                        .padding(.top, 5)
                    HStack {
                        // TODO: - 타이머 적용
                        Text("45:03")
                            .font(.custom(AppFont.semiBold, size: 52))
                            .foregroundStyle(.main)
                        Spacer()
                        Button {
                            isShowingSheet.toggle()
                        } label: {
                            ZStack {
                                Rectangle()
                                    .frame(width: 106, height: 41)
                                    .cornerRadius(9)
                                    .foregroundStyle(.gray1)
                                Text("참여하기")
                                    .font(.custom(AppFont.medium, size: 17))
                                    .foregroundStyle(.white)
                            }
                        }
                        .sheet(isPresented: $isShowingSheet) {
                            StrechFullSheet(isShowingSheet: $isShowingSheet)
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
                        .foregroundStyle(.white)
                    Spacer()
                }
                Chart {
                    ForEach(records, id: \.self) { record in
                        LineMark(
                            x: .value("Day", dateString(from: record.date)),
                            y: .value("Sales", record.togetherPeople[0])
                        )
                        .foregroundStyle(.main)
                    }
                }
                .chartYAxis(content: {
                    AxisMarks(values: [0, 25, 50, 75, 100])
                })
                .frame(height: 327)
                .background(Color.gray0)
            }
            
            // Bottom
            VStack(spacing: 8) {
                Toggle(isOn: $isNotificationOn, label: {
                    Text("시간")
                        .font(.custom(AppFont.semiBold, size: 17))
                })
                .onChange(of: isNotificationOn) { _, newValue in
                    if newValue {
                        notificationManager.requestAuthorization { success in
                            if success {
                                print("Notification authorization granted.")
                                // TODO: - 시작 시간과 종료 시간 사이에만 알림 전송 로직 구현
                                
//                                let timeInterval = endTime.timeIntervalSince(startTime)
                                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 300, repeats: true)
                                notificationManager.scheduleNotification(trigger: trigger)
                            } else {
                                print("Notification authorization denied.")
                                isNotificationOn = false
                            }
                        }
                    } else {
                        notificationManager.cancelNotification()
                    }
                }
                
                TimeList(startTime: $startTime, endTime: $endTime)
            }
        }
        .padding(.horizontal, 16)
    }
    private func dateString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd" // Adjust format as needed
        return dateFormatter.string(from: date)
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
                    .foregroundStyle(.gray0)
                HStack {
                    Text("시작 시간")
                    Spacer()
                    DatePicker("", selection: $startTime, displayedComponents: .hourAndMinute)
                        .datePickerStyle(.compact)
                        .labelsHidden()
                }
                .padding(.horizontal, 16)
            }
            ZStack {
                Rectangle()
                    .frame(height: 53)
                    .cornerRadius(13)
                    .foregroundStyle(.gray0)
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
}

#Preview{
    HomeView(startTime: Date())
}
