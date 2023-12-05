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
    
    //debounce Temps
    @State private var debounceTemp1 = false
    @State private var debounceTemp2 = false
    @State private var debounceTemp3 = false
    @State private var debounceTemp4 = false
    @State private var debounceTemp5 = false
    @State private var debounceTemp6 = false
    @State private var debounceTemp7 = false
    @State private var debounceTemp8 = false
    @State private var debounceTemp9 = false
    @State private var debounceTemp10 = false
    @State private var debounceTemp11 = false
    @State private var debounceTemp12 = false
    @State private var debounceTemp13 = false
    @State private var debounceTemp14 = false
    
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
        if settings.threePedal == false {
            if settings.pedalDirection == "Right" {
                if settings.sustainToggleInverse == true {
                    sessionMode = 1
                    return
                } else {
                    sessionMode = 0
                }
            } 
            else if settings.pedalDirection == "Left" {
                if settings.sustainToggleInverse == true {
                    sessionMode = 0
                } else {
                    sessionMode = 1
                }
            }
            else if settings.pedalDirection == "Both" {
                if settings.sustainToggleInverse == true {
                    sessionMode = 3
                } else {
                    sessionMode = 2
                }
            } 
            else if settings.pedalDirection == "Down" {
                if settings.sustainToggleInverse == true {
                    sessionMode = 9
                } else {
                    sessionMode = 8
                }
            }
        } else if settings.threePedal == true {
            if (rightPedal.inverse == false) && (leftPedal.inverse == false) {
                sessionMode = 4
            } else if (rightPedal.inverse == true) && (leftPedal.inverse == false) {
                sessionMode = 5
            } else if (rightPedal.inverse == false) && (leftPedal.inverse == true) {
                sessionMode = 6
            } else if (rightPedal.inverse == true) && (leftPedal.inverse == true) {
                sessionMode = 7
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
                        // 1P Right or 1P Left Inverse
                    case 0:
                        TiltAngleBar1PRoll(tiltAngle: faceTracking.roll, selectedAngle: settings.pedalRadians)
                            .onChange(of: faceTracking.roll) { newValue in
                                if debounceTemp1 == false {
                                    if newValue > settings.pedalRadians {
                                        if settings.sustainToggleHold == false {
                                            isRollAboveThreshold = true
                                            debounceTemp1 = true
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
                                                debounceTemp1 = false
                                            }
                                        } else {
                                            if (pedalHoldOn == false) && (resetHold == false) {
                                                isRollAboveThreshold = true
                                                pedalHoldOn = true
                                                debounceTemp1 = true
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
                                                    debounceTemp1 = false
                                                }
                                            } else if (pedalHoldOn == true) && (resetHold == true) {
                                                isRollAboveThreshold = false
                                                pedalHoldOn = false
                                                debounceTemp1 = true
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
                                                    debounceTemp1 = false
                                                }
                                            }
                                        }
                                    } else if newValue <= settings.pedalRadians {
                                        if settings.sustainToggleHold == false {
                                            isRollAboveThreshold = false
                                        } else {
                                            if pedalHoldOn == true {
                                                resetHold = true
                                            } else {
                                                resetHold = false
                                            }
                                        }
                                    }
                                }
                            }
                            .onChange(of: isRollAboveThreshold) { newValue in
                                updatePedalStateByte(pedalIndex: 2, isOn: newValue)
                                bleServer.updateAndNotify(value: String(pedalStateByte))
                            }
                            .padding()
                            .rotationEffect(.degrees(180), anchor: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        // 1P Left or 1P Right Inverse
                    case 1:
                        TiltAngleBar1PRoll(tiltAngle: faceTracking.roll, selectedAngle: settings.pedalRadians)
                            .onChange(of: faceTracking.roll) { newValue in
                                if debounceTemp2 == false {
                                    if newValue < settings.pedalRadians {
                                        if settings.sustainToggleHold == false {
                                            isRollAboveThreshold = true
                                            debounceTemp2 = true
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
                                                debounceTemp2 = false
                                            }
                                        } else {
                                            if (pedalHoldOn == false) && (resetHold == false) {
                                                isRollAboveThreshold = true
                                                pedalHoldOn = true
                                                debounceTemp2 = true
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
                                                    debounceTemp2 = false
                                                }
                                            } else if (pedalHoldOn == true) && (resetHold == true) {
                                                isRollAboveThreshold = false
                                                pedalHoldOn = false
                                                debounceTemp2 = true
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
                                                    debounceTemp2 = false
                                                }
                                            }
                                        }
                                    } else if newValue >= settings.pedalRadians {
                                        if settings.sustainToggleHold == false {
                                            isRollAboveThreshold = false
                                            debounceTemp2 = true
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
                                                debounceTemp2 = false
                                            }
                                        } else {
                                            if pedalHoldOn == true {
                                                resetHold = true
                                            } else {
                                                resetHold = false
                                            }
                                        }
                                    }
                                }
                            }
                        
                            .onChange(of: isRollAboveThreshold) { newValue in
                                updatePedalStateByte(pedalIndex: 2, isOn: newValue)
                                bleServer.updateAndNotify(value: String(pedalStateByte))
                            }
                            .padding()
                            .rotationEffect(.degrees(180), anchor: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        // 1P Both
                    case 2:
                        TiltAngleBarBoth(tiltAngle: faceTracking.roll, selectedLeftAngle: settings.pedalRadians, selectedRightAngle: settings.bothRadians)
                            .onChange(of: faceTracking.roll) { newValue in
                                if debounceTemp3 == false {
                                    if (settings.bothRadians < newValue) && (newValue < settings.pedalRadians) {
                                        isRollAboveThreshold = false
                                        debounceTemp3 = true
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
                                            debounceTemp3 = false
                                        }
                                    } else {
                                        isRollAboveThreshold = true
                                        debounceTemp3 = true
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
                                            debounceTemp3 = false
                                        }
                                    }
                                }
                            }
                            .onChange(of: isRollAboveThreshold) { newValue in
                                updatePedalStateByte(pedalIndex: 2, isOn: newValue)
                                bleServer.updateAndNotify(value: String(pedalStateByte))
                            }
                            .padding()
                            .rotationEffect(.degrees(180), anchor: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        // 1P Both Inverse
                    case 3:
                        TiltAngleBarBoth(tiltAngle: faceTracking.roll, selectedLeftAngle: settings.pedalRadians, selectedRightAngle: settings.bothRadians)
                            .onChange(of: faceTracking.roll) { newValue in
                                if debounceTemp4 == false {
                                    if (settings.bothRadians < newValue) && (newValue < settings.pedalRadians) {
                                        isRollAboveThreshold = true
                                        debounceTemp4 = true
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
                                            debounceTemp4 = false
                                        }
                                    } else {
                                        isRollAboveThreshold = false
                                        debounceTemp4 = true
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
                                            debounceTemp4 = false
                                        }
                                    }
                                }
                            }
                            .onChange(of: isRollAboveThreshold) { newValue in
                                updatePedalStateByte(pedalIndex: 2, isOn: newValue)
                                bleServer.updateAndNotify(value: String(pedalStateByte))
                            }
                            .padding()
                            .rotationEffect(.degrees(180), anchor: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        // 3P (Both non-inverse):
                    case 4:
                        VStack {
                            TiltAngleBarBoth(tiltAngle: faceTracking.roll, selectedLeftAngle: leftPedal.angle, selectedRightAngle: rightPedal.angle)
                                .onChange(of: faceTracking.roll) { newValue in
                                    if debounceTemp5 == false {
                                        if newValue > rightPedal.angle {
                                            isRollAboveRightThreshold = true
                                            debounceTemp5 = true
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
                                                debounceTemp5 = false
                                            }
                                            if newValue >= leftPedal.angle {
                                                isRollAboveLeftThreshold = false
                                                debounceTemp5 = true
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
                                                    debounceTemp5 = false
                                                }
                                            }
                                        } else if newValue <= rightPedal.angle {
                                            isRollAboveRightThreshold = false
                                            debounceTemp5 = true
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
                                                debounceTemp5 = false
                                            }
                                            if newValue < leftPedal.angle {
                                                isRollAboveLeftThreshold = true
                                                debounceTemp5 = true
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
                                                    debounceTemp5 = false
                                                }
                                            } else if newValue >= leftPedal.angle {
                                                isRollAboveLeftThreshold = false
                                                debounceTemp5 = true
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
                                                    debounceTemp5 = false
                                                }
                                            }
                                        }
                                    }
                                }
                                .onChange(of: isRollAboveRightThreshold) { newValue in
                                    if rightPedal.state == true {
                                        let pedalIndex = rightPedal.type // Assuming rightPedal.type returns 0, 1, or 2
                                        updatePedalStateByte(pedalIndex: pedalIndex, isOn: newValue)
                                        bleServer.updateAndNotify(value: String(pedalStateByte))
                                    }
                                }
                                .onChange(of: isRollAboveLeftThreshold) { newValue in
                                    if leftPedal.state == true {
                                        let pedalIndex = leftPedal.type // Assuming rightPedal.type returns 0, 1, or 2
                                        updatePedalStateByte(pedalIndex: pedalIndex, isOn: newValue)
                                        bleServer.updateAndNotify(value: String(pedalStateByte))
                                    }
                                }
                                .padding()
                                .rotationEffect(.degrees(180), anchor: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            
                            TiltAngleBarPitch(tiltAngle: faceTracking.pitch, selectedAngle: settings.softRadians)
                                .onChange(of: faceTracking.pitch) { newValue in
                                    if debounceTemp6 == false {
                                        if (newValue < midPedal.angle) && (midPedal.inverse == true) {
                                            isRollAboveMidThreshold = true
                                            debounceTemp6 = true
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) {
                                                debounceTemp6 = false
                                            }
                                        } else if (newValue > midPedal.angle) && (midPedal.inverse == true) {
                                            isRollAboveMidThreshold = false
                                            debounceTemp6 = true
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) {
                                                debounceTemp6 = false
                                            }
                                        } else if (newValue > midPedal.angle) && (midPedal.inverse == false) {
                                            isRollAboveMidThreshold = true
                                            debounceTemp6 = true
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) {
                                                debounceTemp6 = false
                                            }
                                        } else if (newValue < midPedal.angle) && (midPedal.inverse == false) {
                                            isRollAboveMidThreshold = false
                                            debounceTemp6 = true
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) {
                                                debounceTemp6 = false
                                            }
                                        }
                                    }
                                }
                                .onChange(of: isRollAboveMidThreshold) { newValue in
                                    if midPedal.state == true {
                                        let pedalIndex = midPedal.type // Assuming rightPedal.type returns 0, 1, or 2
                                        updatePedalStateByte(pedalIndex: pedalIndex, isOn: newValue)
                                        bleServer.updateAndNotify(value: String(pedalStateByte))
                                    }
                                }
                                .padding()
                                .frame(height: 200)
                                .offset(x: (geometry.size.width / 2) - 47.5)
                            
                        }
                        // 3P (Right-Inverse)
                    case 5:
                        VStack {
                            TiltAngleBarBoth(tiltAngle: faceTracking.roll, selectedLeftAngle: leftPedal.angle, selectedRightAngle: rightPedal.angle)
                                .onChange(of: faceTracking.roll) { newValue in
                                    if debounceTemp7 == false {
                                        if newValue < rightPedal.angle {
                                            isRollAboveRightThreshold = true
                                            debounceTemp7 = true
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
                                                debounceTemp7 = false
                                            }
                                            if newValue < leftPedal.angle {
                                                isRollAboveLeftThreshold = true
                                                debounceTemp7 = true
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
                                                    debounceTemp7 = false
                                                }
                                            } else if newValue >= leftPedal.angle {
                                                isRollAboveLeftThreshold = false
                                                debounceTemp7 = true
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
                                                    debounceTemp7 = false
                                                }
                                            }
                                        } else if newValue >= rightPedal.angle {
                                            isRollAboveRightThreshold = false
                                            debounceTemp7 = true
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
                                                debounceTemp7 = false
                                            }
                                            if newValue >= leftPedal.angle {
                                                isRollAboveLeftThreshold = false
                                                debounceTemp7 = true
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
                                                    debounceTemp7 = false
                                                }
                                            }
                                        }
                                    }
                                }
                                .onChange(of: isRollAboveRightThreshold) { newValue in
                                    if rightPedal.state == true {
                                        let pedalIndex = rightPedal.type // Assuming rightPedal.type returns 0, 1, or 2
                                        updatePedalStateByte(pedalIndex: pedalIndex, isOn: newValue)
                                        bleServer.updateAndNotify(value: String(pedalStateByte))
                                    }
                                }
                                .onChange(of: isRollAboveLeftThreshold) { newValue in
                                    if leftPedal.state == true {
                                        let pedalIndex = leftPedal.type // Assuming rightPedal.type returns 0, 1, or 2
                                        updatePedalStateByte(pedalIndex: pedalIndex, isOn: newValue)
                                        bleServer.updateAndNotify(value: String(pedalStateByte))
                                    }
                                }
                                .padding()
                                .rotationEffect(.degrees(180), anchor: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            
                            TiltAngleBarPitch(tiltAngle: faceTracking.pitch, selectedAngle: settings.softRadians)
                                .onChange(of: faceTracking.pitch) { newValue in
                                    if debounceTemp8 == false {
                                        if (newValue < midPedal.angle) && (midPedal.inverse == true) {
                                            isRollAboveMidThreshold = true
                                            debounceTemp8 = true
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) {
                                                debounceTemp8 = false
                                            }
                                        } else if (newValue > midPedal.angle) && (midPedal.inverse == true) {
                                            isRollAboveMidThreshold = false
                                            debounceTemp8 = true
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) {
                                                debounceTemp8 = false
                                            }
                                        } else if (newValue > midPedal.angle) && (midPedal.inverse == false) {
                                            isRollAboveMidThreshold = true
                                            debounceTemp8 = true
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) {
                                                debounceTemp8 = false
                                            }
                                        } else if (newValue < midPedal.angle) && (midPedal.inverse == false) {
                                            isRollAboveMidThreshold = false
                                            debounceTemp8 = true
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) {
                                                debounceTemp8 = false
                                            }
                                        }
                                    }
                                }
                                .onChange(of: isRollAboveMidThreshold) { newValue in
                                    if midPedal.state == true {
                                        let pedalIndex = midPedal.type // Assuming rightPedal.type returns 0, 1, or 2
                                        updatePedalStateByte(pedalIndex: pedalIndex, isOn: newValue)
                                        bleServer.updateAndNotify(value: String(pedalStateByte))
                                    }
                                }
                                .padding()
                                .frame(height: 200)
                                .offset(x: (geometry.size.width / 2) - 47.5)
                            
                        }
                        // 3P (Left-inverse)
                    case 6:
                        VStack {
                            TiltAngleBarBoth(tiltAngle: faceTracking.roll, selectedLeftAngle: leftPedal.angle, selectedRightAngle: rightPedal.angle)
                                .onChange(of: faceTracking.roll) { newValue in
                                    if debounceTemp9 == false {
                                        if newValue > rightPedal.angle {
                                            isRollAboveRightThreshold = true
                                            debounceTemp9 = true
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
                                                debounceTemp9 = false
                                            }
                                            if newValue <= leftPedal.angle {
                                                isRollAboveLeftThreshold = false
                                                debounceTemp9 = true
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
                                                    debounceTemp9 = false
                                                }
                                            }
                                        } else if newValue <= rightPedal.angle {
                                            isRollAboveRightThreshold = false
                                            debounceTemp9 = true
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
                                                debounceTemp9 = false
                                            }
                                            if newValue > leftPedal.angle {
                                                isRollAboveLeftThreshold = true
                                                debounceTemp9 = true
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
                                                    debounceTemp9 = false
                                                }
                                            } else if newValue <= leftPedal.angle {
                                                isRollAboveLeftThreshold = false
                                                debounceTemp9 = true
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
                                                    debounceTemp9 = false
                                                }
                                            }
                                        }
                                    }
                                }
                                .onChange(of: isRollAboveRightThreshold) { newValue in
                                    if rightPedal.state == true {
                                        let pedalIndex = rightPedal.type // Assuming rightPedal.type returns 0, 1, or 2
                                        updatePedalStateByte(pedalIndex: pedalIndex, isOn: newValue)
                                        bleServer.updateAndNotify(value: String(pedalStateByte))
                                    }
                                }
                                .onChange(of: isRollAboveLeftThreshold) { newValue in
                                    if leftPedal.state == true {
                                        let pedalIndex = leftPedal.type // Assuming rightPedal.type returns 0, 1, or 2
                                        updatePedalStateByte(pedalIndex: pedalIndex, isOn: newValue)
                                        bleServer.updateAndNotify(value: String(pedalStateByte))
                                    }
                                }
                                .padding()
                                .rotationEffect(.degrees(180), anchor: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            
                            TiltAngleBarPitch(tiltAngle: faceTracking.pitch, selectedAngle: settings.softRadians)
                                .onChange(of: faceTracking.pitch) { newValue in
                                    if debounceTemp10 == false {
                                        if (newValue < midPedal.angle) && (midPedal.inverse == true) {
                                            isRollAboveMidThreshold = true
                                            debounceTemp10 = true
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) {
                                                debounceTemp10 = false
                                            }
                                        } else if (newValue > midPedal.angle) && (midPedal.inverse == true) {
                                            isRollAboveMidThreshold = false
                                            debounceTemp10 = true
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) {
                                                debounceTemp10 = false
                                            }
                                        } else if (newValue > midPedal.angle) && (midPedal.inverse == false) {
                                            isRollAboveMidThreshold = true
                                            debounceTemp10 = true
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) {
                                                debounceTemp10 = false
                                            }
                                        } else if (newValue < midPedal.angle) && (midPedal.inverse == false) {
                                            isRollAboveMidThreshold = false
                                            debounceTemp10 = true
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) {
                                                debounceTemp10 = false
                                            }
                                        }
                                    }
                                }
                                .onChange(of: isRollAboveMidThreshold) { newValue in
                                    if midPedal.state == true {
                                        let pedalIndex = midPedal.type // Assuming rightPedal.type returns 0, 1, or 2
                                        updatePedalStateByte(pedalIndex: pedalIndex, isOn: newValue)
                                        bleServer.updateAndNotify(value: String(pedalStateByte))
                                    }
                                }
                                .padding()
                                .frame(height: 200)
                                .offset(x: (geometry.size.width / 2) - 47.5)
                            
                        }
                        // 3P (Both-inverse)
                    case 7:
                        VStack {
                            TiltAngleBarBoth(tiltAngle: faceTracking.roll, selectedLeftAngle: leftPedal.angle, selectedRightAngle: rightPedal.angle)
                                .onChange(of: faceTracking.roll) { newValue in
                                    if debounceTemp11 == false {
                                        if newValue < rightPedal.angle {
                                            isRollAboveRightThreshold = true
                                            debounceTemp11 = true
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
                                                debounceTemp11 = false
                                            }
                                            if newValue <= leftPedal.angle {
                                                isRollAboveLeftThreshold = false
                                                debounceTemp11 = true
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
                                                    debounceTemp11 = false
                                                }
                                            } else if newValue > leftPedal.angle {
                                                isRollAboveLeftThreshold = true
                                                debounceTemp11 = true
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
                                                    debounceTemp11 = false
                                                }
                                            }
                                        } else if newValue >= rightPedal.angle {
                                            isRollAboveRightThreshold = false
                                            debounceTemp11 = true
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
                                                debounceTemp11 = false
                                            }
                                            if newValue > leftPedal.angle {
                                                isRollAboveLeftThreshold = true
                                                debounceTemp11 = true
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
                                                    debounceTemp11 = false
                                                }
                                            } else if newValue <= leftPedal.angle {
                                                isRollAboveLeftThreshold = false
                                                debounceTemp11 = true
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
                                                    debounceTemp11 = false
                                                }
                                            }
                                        }
                                    }
                                }
                                .onChange(of: isRollAboveRightThreshold) { newValue in
                                    if rightPedal.state == true {
                                        let pedalIndex = rightPedal.type // Assuming rightPedal.type returns 0, 1, or 2
                                        updatePedalStateByte(pedalIndex: pedalIndex, isOn: newValue)
                                        bleServer.updateAndNotify(value: String(pedalStateByte))
                                    }
                                }
                                .onChange(of: isRollAboveLeftThreshold) { newValue in
                                    if leftPedal.state == true {
                                        let pedalIndex = leftPedal.type // Assuming rightPedal.type returns 0, 1, or 2
                                        updatePedalStateByte(pedalIndex: pedalIndex, isOn: newValue)
                                        bleServer.updateAndNotify(value: String(pedalStateByte))
                                    }
                                }
                                .padding()
                                .rotationEffect(.degrees(180), anchor: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            
                            TiltAngleBarPitch(tiltAngle: faceTracking.pitch, selectedAngle: settings.softRadians)
                                .onChange(of: faceTracking.pitch) { newValue in
                                    if debounceTemp12 == false {
                                        if (newValue < midPedal.angle) && (midPedal.inverse == true) {
                                            isRollAboveMidThreshold = true
                                            debounceTemp12 = true
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) {
                                                debounceTemp12 = false
                                            }
                                        } else if (newValue > midPedal.angle) && (midPedal.inverse == true) {
                                            isRollAboveMidThreshold = false
                                            debounceTemp12 = true
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) {
                                                debounceTemp12 = false
                                            }
                                        } else if (newValue > midPedal.angle) && (midPedal.inverse == false) {
                                            isRollAboveMidThreshold = true
                                            debounceTemp12 = true
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) {
                                                debounceTemp12 = false
                                            }
                                        } else if (newValue < midPedal.angle) && (midPedal.inverse == false) {
                                            isRollAboveMidThreshold = false
                                            debounceTemp12 = true
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) {
                                                debounceTemp12 = false
                                            }
                                        }
                                    }
                                }
                                .onChange(of: isRollAboveMidThreshold) { newValue in
                                    if midPedal.state == true {
                                        let pedalIndex = midPedal.type // Assuming rightPedal.type returns 0, 1, or 2
                                        updatePedalStateByte(pedalIndex: pedalIndex, isOn: newValue)
                                        bleServer.updateAndNotify(value: String(pedalStateByte))
                                    }
                                }
                                .padding()
                                .frame(height: 200)
                                .offset(x: (geometry.size.width / 2) - 47.5)
                        }
                    // 1P Down Non-inverse
                    case 8:
                        TiltAngleBarPitch(tiltAngle: faceTracking.pitch, selectedAngle: settings.pedalRadians)
                            .onChange(of: faceTracking.pitch) { newValue in
                                if debounceTemp13 == false {
                                    if newValue > settings.pedalRadians {
                                        if settings.sustainToggleHold == false {
                                            isRollAboveThreshold = true
                                            debounceTemp13 = true
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
                                                debounceTemp13 = false
                                            }
                                        } else {
                                            if (pedalHoldOn == false) && (resetHold == false) {
                                                isRollAboveThreshold = true
                                                pedalHoldOn = true
                                                debounceTemp13 = true
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
                                                    debounceTemp13 = false
                                                }
                                            } else if (pedalHoldOn == true) && (resetHold == true) {
                                                isRollAboveThreshold = false
                                                pedalHoldOn = false
                                                debounceTemp13 = true
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
                                                    debounceTemp13 = false
                                                }
                                            }
                                        }
                                    } else if newValue <= settings.pedalRadians {
                                        if settings.sustainToggleHold == false {
                                            isRollAboveThreshold = false
                                        } else {
                                            if pedalHoldOn == true {
                                                resetHold = true
                                            } else {
                                                resetHold = false
                                            }
                                        }
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
                    // 1P Down Inverse
                    case 9:
                        TiltAngleBarPitch(tiltAngle: faceTracking.pitch, selectedAngle: settings.pedalRadians)
                            .onChange(of: faceTracking.pitch) { newValue in
                                if debounceTemp2 == false {
                                    if newValue < settings.pedalRadians {
                                        if settings.sustainToggleHold == false {
                                            isRollAboveThreshold = true
                                            debounceTemp2 = true
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
                                                debounceTemp2 = false
                                            }
                                        } else {
                                            if (pedalHoldOn == false) && (resetHold == false) {
                                                isRollAboveThreshold = true
                                                pedalHoldOn = true
                                                debounceTemp2 = true
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
                                                    debounceTemp2 = false
                                                }
                                            } else if (pedalHoldOn == true) && (resetHold == true) {
                                                isRollAboveThreshold = false
                                                pedalHoldOn = false
                                                debounceTemp2 = true
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
                                                    debounceTemp2 = false
                                                }
                                            }
                                        }
                                    } else if newValue >= settings.pedalRadians {
                                        if settings.sustainToggleHold == false {
                                            isRollAboveThreshold = false
                                            debounceTemp2 = true
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
                                                debounceTemp2 = false
                                            }
                                        } else {
                                            if pedalHoldOn == true {
                                                resetHold = true
                                            } else {
                                                resetHold = false
                                            }
                                        }
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
                        
                    default:
                        Text("ERROR INVALID SETTINGS")
                            .padding()
                    }
                    
                    if (sessionMode == 8) || (sessionMode == 9) {
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
