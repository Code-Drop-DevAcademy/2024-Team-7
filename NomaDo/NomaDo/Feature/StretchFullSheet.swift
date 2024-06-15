//
//  StretchSheet.swift
//  NomaDo
//
//  Created by Seo-Jooyoung on 6/15/24.
//

import SwiftUI

struct StrechFullSheet: View {
    @State private var runningTimer = ""
    @State private var isShowingPause = false
    @State private var nextHourInt: Double = 1
    @State private var stretchTime: Double = 60.0
    @State private var stretchStart: Bool = false
    @State private var celebration: Bool = false
    @State private var rightLeft: Bool = true
    
    @Binding var isShowingSheet : Bool
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    isShowingSheet = false
                }, label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .foregroundStyle(Color.main)
                })
                
                Spacer()
                
                Button(action:{
                    stretchStart.toggle()
                }, label:{
                    Text("임시버튼")
                        .foregroundStyle(Color.main)
                })
            }
            .padding(.vertical)
            .padding(.horizontal)
            
            Spacer()
            
            if !stretchStart {
                HStack {
                    TimerView(downloadAmount: $nextHourInt, runningTimer: $runningTimer, isShowingPause: $isShowingPause)
                    Text("후에 시작합니다")
                        .font(.custom(AppFont.semiBold, size: 30))
                        .foregroundStyle(Color.white)
                }
            } else {
                Text("35명의 노마드와 함께 진행 중")
                    .font(.custom(AppFont.medium, size: 20))
                    .foregroundStyle(Color.white)
            }
            
            if rightLeft {
                Image("Yoga_right")
                    .background(
                        Circle()
                            .foregroundStyle(Color.gray)
                            .frame(width: 325, height: 325)
                            .offset(y:-4)
                    )
            } else {
                Image("Yoga_left")
                    .background(
                        Circle()
                            .foregroundStyle(Color.gray)
                            .frame(width: 325, height: 325)
                            .offset(y:-4)
                    )
            }
            
            if stretchStart {
                VStack {
                    Text("00:\(Int(stretchTime))")
                        .foregroundStyle(Color.white)
                    TimerBar(downloadAmount: $stretchTime)
                    RoundedRectangle(cornerSize: CGSize(width: 9, height: 9))
                        .foregroundColor(Color.gray)
                        .frame(height: 113)
                        .opacity(0)
                        .padding(.horizontal, 13)
                        .overlay{
                            VStack{
                                Text("온몸 운동")
                                    .font(.custom(AppFont.bold, size: 20))
                                    .foregroundStyle(Color.white)
                                Spacer()
                                Text("의자에 앉은 상태에서 허리를 곧게 펴고")
                                    .font(.custom(AppFont.medium, size: 17))
                                    .foregroundStyle(Color.white)
                                Text("양 손을 등뒤로 넘겨 맞잡아주세요!")
                                    .font(.custom(AppFont.medium, size: 17))
                                    .foregroundStyle(Color.white)
                            }.padding()
                            
                        }
                }.onAppear {
                    stretchTime = 60.0
                }
                .onReceive(timer) { _ in
                    if stretchTime > 0{
                        stretchTime -= 1
                    }
                    if stretchTime == 30.0{
                        rightLeft = false
                    } else if stretchTime == 0 {
                        stretchStart = false
                        celebration = true
                    }
                }
            } else {
                Text("32명의 노마드가 대기 중")
                    .font(.custom(AppFont.semiBold, size: 20))
            }
            Spacer()
            if celebration {
                Text("축하합니다!")
                    .font(.custom(AppFont.bold, size: 20))
                    .padding()
                    .foregroundStyle(Color.white)
                Text("35명의 노마드와 함께 스트레칭을 완료했습니다.")
                    .font(.custom(AppFont.medium, size: 17))
                    .padding(.bottom, 15)
                    .foregroundStyle(Color.white)
                Button(action:{
                    // showingSheetTrue.toggle()
                }, label:{
                    RoundedRectangle(cornerSize: CGSize(width: 13, height: 13))
                        .frame(height:49)
                        .padding(.horizontal, 15)
                        .foregroundStyle(Color.gray)
                        .overlay{
                            Text("확인")
                                .font(.custom(AppFont.medium, size: 17))
                                .foregroundStyle(Color.white)
                        }
                })
            }
            
        }
        .onAppear {
            let calendar = Calendar.current
            let currentTime = Date()
            let nextHour = calendar.date(byAdding: .hour, value: 1, to: currentTime)!
            let nextHourStart = calendar.dateInterval(of: .hour, for: nextHour)!.start
            self.nextHourInt = Double(nextHourStart.timeIntervalSince(currentTime))
        }
        
        .onChange(of: rightLeft) { _, newValue in
            if newValue {
                // celebration이 true로 변경되었을 때 실행할 작업
                print("Celebration started")
            }
            
        }
    }
}
