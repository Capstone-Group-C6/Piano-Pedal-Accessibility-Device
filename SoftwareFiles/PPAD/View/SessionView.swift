//
//  SessionView.swift
//  PPAD
//
//  Created by Roberto Chadwick on 11/27/23.
//

import SwiftUI

struct SessionView: View {
    @EnvironmentObject var settings: Settings
    @ObservedObject var faceTracking: FaceTracking
    var bleServer: BLEServer
    
    @State var soloPedal: Pedal
    
    @State var rightPedal: Pedal
    @State var leftPedal: Pedal
    @State var midPedal: Pedal
    
    @State private var isRollAboveThreshold = false
    
    @State private var isRollAboveRightThreshold = false
    @State private var isRollAboveMidThreshold = false
    @State private var isRollAboveLeftThreshold = false
    
    @State private var pedalHoldOn = false
    @State private var rightHoldOn = false
    @State private var midHoldOn = false
    @State private var leftHoldOn = false
    
    @State private var resetHold = false
    
    //debounce Temps a new debounce temp is made for every test case
    @State private var debounceTemp1 = false
    @State private var debounceTemp2 = false
    @State private var debounceTemp3 = false
    
    // need to check for inverse before assigning
    @State var sessionMode: Double = 0
    
    @State var pedalStateByte: UInt8 = 0

    func updatePedalStateByte(pedalIndex: Int, isOn: Bool) {
        let bitMask: UInt8 = 1 << pedalIndex
        if isOn {
            pedalStateByte |= bitMask
        } else {
            pedalStateByte &= ~bitMask
        }
    }
    
    func modeSelect() {
        if settings.threePedal == true {
            sessionMode = 3
        } else {
            if settings.pedalDirection == "Down" {
                sessionMode = 2
            } else if settings.pedalDirection == "Both" {
                sessionMode = 1
            } else {
                sessionMode = 0
            }
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                VStack{
                    Text("PLAYING")
                        .font(.system(.largeTitle, design: .rounded))
                        .foregroundStyle(.gray)
                        .padding()
                    
                    switch sessionMode {
                    // 1P1D Horizontal Mode
                    case 0:
                        TiltAngleBar1PRoll(tiltAngle: faceTracking.roll, selectedAngle: settings.pedalRadians)
                            .onChange(of: faceTracking.roll) { newValue in
                                if debounceTemp1 == false {
                                    debounceTemp1 = true
                                    
                                    if settings.pedalDirection == "Right" {
                                        isRollAboveThreshold = soloPedal.isAboveThreshold(highValue: newValue, lowValue: settings.pedalRadians)
                                    } else {
                                        isRollAboveThreshold = soloPedal.isAboveThreshold(highValue: settings.pedalRadians, lowValue: newValue)
                                    }
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
                                        debounceTemp1 = false
                                    }
                                }
                            }
                            .onChange(of: isRollAboveThreshold) { newValue in
                                updatePedalStateByte(pedalIndex: 2, isOn: newValue)
                                bleServer.updateAndNotify(value: String(pedalStateByte))
                            }
                            .padding()
                            .rotationEffect(.degrees(180), anchor: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    // 1P2D Horizontal Mode
                    // INVERSE NOT WORKING
                    case 1:
                        TiltAngleBarBoth(tiltAngle: faceTracking.roll, selectedLeftAngle: settings.pedalRadians, selectedRightAngle: settings.bothRadians)
                            .onChange(of: faceTracking.roll) { newValue in
                                if debounceTemp1 == false {
                                    debounceTemp1 = true
                        
                                    let checkRightThreshold = soloPedal.isAboveThreshold(highValue: newValue, lowValue: settings.pedalRadians)
                                    let checkLeftThreshold = soloPedal.isAboveThreshold(highValue: settings.bothRadians, lowValue: newValue)
                                    
                                    if soloPedal.inverse == false {
                                        if (checkLeftThreshold || checkRightThreshold) == true {
                                            isRollAboveThreshold = true
                                        } else {
                                            isRollAboveThreshold = false
                                        }
                                    } else {
                                        if (checkLeftThreshold && checkRightThreshold) == true {
                                            isRollAboveThreshold = true
                                        } else {
                                            isRollAboveThreshold = false
                                        }
                                    }
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
                                        debounceTemp1 = false
                                    }
                                }
                            }
                            .onChange(of: isRollAboveThreshold) { newValue in
                                updatePedalStateByte(pedalIndex: 2, isOn: newValue)
                                bleServer.updateAndNotify(value: String(pedalStateByte))
                            }
                            .padding()
                            .rotationEffect(.degrees(180), anchor: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    // 1P1D Vertical Mode
                    case 2:
                        TiltAngleBarPitch(tiltAngle: faceTracking.pitch, selectedAngle: settings.pedalRadians)
                            .onChange(of: faceTracking.pitch) { newValue in
                                if debounceTemp1 == false {
                                    debounceTemp1 = true
                                
                                    isRollAboveThreshold = soloPedal.isAboveThreshold(highValue: newValue, lowValue: settings.pedalRadians)
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
                                        debounceTemp1 = false
                                    }
                                }
                            }
                            .onChange(of: isRollAboveThreshold) { newValue in
                                updatePedalStateByte(pedalIndex: 2, isOn: newValue)
                                bleServer.updateAndNotify(value: String(pedalStateByte))
                            }
                            .padding()
                            .frame(height: 500)
                            .offset(x: (geometry.size.width / 2) - 47.5)
                    // 3P Mode
                    case 3:
                        TiltAngleBarBoth(tiltAngle: faceTracking.roll, selectedLeftAngle: leftPedal.angle, selectedRightAngle: rightPedal.angle)
                            .onChange(of: faceTracking.roll) { newValue in
                                if debounceTemp1 == false {
                                    debounceTemp1 = true
                                    
                                    isRollAboveLeftThreshold = leftPedal.isAboveThreshold(highValue: leftPedal.angle, lowValue: newValue)
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
                                        debounceTemp1 = false
                                    }
                                }
                                
                                if debounceTemp2 == false {
                                    debounceTemp2 = true
                                    isRollAboveRightThreshold = rightPedal.isAboveThreshold(highValue: newValue, lowValue: rightPedal.angle)
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
                                        debounceTemp2 = false
                                    }
                                }
                            }
                            .onChange(of: isRollAboveLeftThreshold) { newValue in
                                updatePedalStateByte(pedalIndex: leftPedal.type, isOn: newValue)
                                bleServer.updateAndNotify(value: String(pedalStateByte))
                            }
                            .onChange(of: isRollAboveRightThreshold) { newValue in
                                updatePedalStateByte(pedalIndex: rightPedal.type, isOn: newValue)
                                bleServer.updateAndNotify(value: String(pedalStateByte))
                            }
                            .padding()
                            .rotationEffect(.degrees(180), anchor: .center)
                        
                        TiltAngleBarPitch(tiltAngle: faceTracking.pitch, selectedAngle: settings.softRadians)
                            .onChange(of: faceTracking.pitch) { newValue in
                                if debounceTemp3 == false {
                                    debounceTemp3 = true
                                    
                                    isRollAboveMidThreshold = midPedal.isAboveThreshold(highValue: newValue, lowValue: midPedal.angle)
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
                                        debounceTemp3 = false
                                    }
                                }
                            }
                            .onChange(of: isRollAboveMidThreshold) { newValue in
                                updatePedalStateByte(pedalIndex: midPedal.type, isOn: newValue)
                                bleServer.updateAndNotify(value: String(pedalStateByte))
                            }
                            .padding()
                            .frame(height: 200)
                            .offset(x: (geometry.size.width / 2) - 47.5)
                        
                    default:
                        Text("ERROR INVALID SETTINGS")
                            .padding()
                    }
                    
                    if (sessionMode == 2) {
                        Spacer()
                            .frame(height: 50)
                    } else {
                        Spacer()
                            .frame(height: 150)
                    }
                    
                    PedalIndicator(threePedal: settings.threePedal, onePedal: isRollAboveThreshold, rightPedal: isRollAboveRightThreshold, leftPedal: isRollAboveLeftThreshold, middlePedal: isRollAboveMidThreshold)
                        .padding()
                }
            }
            .onAppear {
                faceTracking.startSession()
                modeSelect()
            }
            .onDisappear {
                faceTracking.stopSession()
            }
        }
    }
}
