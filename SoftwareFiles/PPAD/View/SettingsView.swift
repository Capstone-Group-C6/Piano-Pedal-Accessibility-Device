//
//  SettingsView.swift
//  PPAD
//
//  Created by Roberto Chadwick on 11/27/23.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var faceTracking: FaceTracking
    
    @EnvironmentObject var settings: Settings
    @State private var isSustainEditing = false
    @State private var isSostenutoEditing = false
    @State private var isSoftEditing = false
    let direction = ["Right", "Left", "Both", "Down"]
    let pedalNum = ["1 Pedal", "3 Pedals"]
    let rollMin = 5.0
    let rollMax = 35.0
    let pitchMin = -20.0
    let pitchMax = 40.0
    let defaults = UserDefaults.standard
    
    func switchSustainAngle(){
        if (settings.pedalDirection == "Down"){
            settings.pedalAngle = settings.downAngle
        }
        else if (settings.pedalDirection == "Both"){
            settings.pedalAngle = settings.bothAngle
        }
        else if (settings.pedalDirection == "Left"){
            settings.pedalAngle = settings.leftAngle
        }
        else {
            settings.pedalAngle = settings.rightAngle
        }
        self.degToRad(angle: settings.pedalAngle, pedalName: "onePedal", direction: settings.pedalDirection)
    }
    
    func switchPedalNum(){
        if (settings.pedalNumSelection == "3 Pedals"){
            settings.threePedal = true
        }
        else {
            settings.threePedal = false
        }
    }
    
    func switchSustainSostenuto(){
        if (settings.sustainDirection == "Right"){
            settings.sustainDirection = "Left"
            settings.sostenutoDirection = "Right"
        }
        else {
            settings.sustainDirection = "Right"
            settings.sostenutoDirection = "Left"
        }
        self.degToRad(angle: settings.sustainAngle, pedalName: "sustain", direction: settings.sustainDirection)
        self.degToRad(angle: settings.sostenutoAngle, pedalName: "sostenuto", direction: settings.sostenutoDirection)
    }
    
    func degToRad(angle :Double, pedalName :String, direction :String){
        //store angle change
        
        //rad conversion
        var radConversion = angle * Double.pi/180
        if (direction == "Right"){
            settings.rightAngle = angle
            radConversion = Double.pi/2 + radConversion
        }
        else if (direction == "Left"){
            settings.leftAngle = angle
            radConversion = Double.pi/2 - radConversion
        }
        else if (direction == "Both"){
            settings.bothAngle = angle
            settings.bothRadians = Double.pi/2 - radConversion //left threshold
            radConversion = Double.pi/2 + radConversion //right threshold
        }
        else {
            settings.downAngle = angle
        }
        switch pedalName{
        case "sustain":
            settings.sustainRadians = radConversion
        case "sostenuto":
            settings.sostenutoRadians = radConversion
        case "soft":
            settings.softRadians = radConversion
        default:
            settings.pedalRadians = radConversion
        }
        
        //store rad conversion
    }
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                Form {
                    Section(header: Text("Adjust Pedal Settings")){
                        VStack(){
                            //one pedal (sustain) settings elements
                            Picker("Select Number of Pedals", selection: $settings.pedalNumSelection) {
                                ForEach(pedalNum, id: \.self) {
                                    Text($0)
                                }
                            }
                            .onChange(of: settings.pedalNumSelection, perform:{ num in
                                self.switchPedalNum()
                            })
                            .pickerStyle(.segmented)
                            .padding(EdgeInsets(top: 10, leading: 5, bottom: 0, trailing: 5))
                            
                            //one pedal (sustain) settings elements
                            if (settings.threePedal == false){
                                HStack{
                                    Text("Sustain")
                                        .font(.system(size: 30))
                                    Spacer()
                                }
                                Picker("Select Sustain direction", selection: $settings.pedalDirection) {
                                    ForEach(direction, id: \.self) {
                                        Text($0)
                                    }
                                }
                                .onChange(of: settings.pedalDirection, perform:{ angle in
                                    self.switchSustainAngle()
                                })
                                .pickerStyle(.menu)
                                if (settings.pedalDirection != "Both"){
                                    Toggle(isOn: $settings.sustainToggleHold,
                                           label: {
                                        Text("Toggle Pedal Hold")
                                    })
                                }
                                Toggle(isOn: $settings.sustainToggleInverse,
                                       label: {
                                    Text("Toggle Pedal Inverse")
                                })
                                if settings.pedalDirection == "Down"{
                                    VStack(spacing:20){Text("Tilt Trigger Angle")
                                        Slider(value: $settings.pedalAngle,
                                               in: pitchMin...pitchMax,
                                               step: 0.5
                                        ){Text("Angle")
                                        }minimumValueLabel: {
                                            Text(String(pitchMin))
                                        }maximumValueLabel: {
                                            Text(String(pitchMax))
                                        }onEditingChanged: { editing in
                                            isSustainEditing = editing
                                        }
                                        .onChange(of: settings.pedalAngle, perform:{angle in
                                            self.degToRad(angle: settings.pedalAngle, pedalName: "onePedal", direction: settings.pedalDirection)
                                        })
                                        Text(String(settings.pedalAngle) + "° ")
                                            .foregroundColor(isSustainEditing ? .blue : .white)
                                        TiltAngleBarPitch(tiltAngle: faceTracking.pitch, selectedAngle: settings.pedalRadians)
                                            .frame(height: 150)
                                            .padding()
                                            .offset(x: (geometry.size.width / 2) - 80)
                                    }
                                }
                                else if (settings.pedalDirection == "Both") {
                                    VStack(spacing:20){Text("Tilt Trigger Angle")
                                        Slider(value: $settings.pedalAngle,
                                               in: rollMin...rollMax,
                                               step: 0.5
                                        ){Text("Angle")
                                        }minimumValueLabel: {
                                            Text(String(rollMin))
                                        }maximumValueLabel: {
                                            Text(String(rollMax))
                                        }onEditingChanged: { editing in
                                            isSustainEditing = editing
                                        }
                                        .onChange(of: settings.pedalAngle, perform:{angle in
                                            self.degToRad(angle: settings.pedalAngle, pedalName: "onePedal", direction: settings.pedalDirection)
                                        })
                                        Text(String(settings.pedalAngle) + "° ")
                                            .foregroundColor(isSustainEditing ? .blue : .white)
                                        Spacer()
                                        TiltAngleBarBoth(tiltAngle: faceTracking.roll, selectedLeftAngle: settings.pedalRadians, selectedRightAngle: settings.bothRadians)
                                            .padding()
                                            .rotationEffect(.degrees(180), anchor: .center)
                                    }
                                }
                                else {
                                    VStack(spacing:20){Text("Tilt Trigger Angle")
                                        Slider(value: $settings.pedalAngle,
                                               in: rollMin...rollMax,
                                               step: 0.5
                                        ){Text("Angle")
                                        }minimumValueLabel: {
                                            Text(String(rollMin))
                                        }maximumValueLabel: {
                                            Text(String(rollMax))
                                        }onEditingChanged: { editing in
                                            isSustainEditing = editing
                                        }
                                        .onChange(of: settings.pedalAngle, perform:{angle in
                                            self.degToRad(angle: settings.pedalAngle, pedalName: "onePedal", direction: settings.pedalDirection)
                                        })
                                        Text(String(settings.pedalAngle) + "° ")
                                            .foregroundColor(isSustainEditing ? .blue : .white)
                                        Spacer()
                                        TiltAngleBar1PRoll(tiltAngle: faceTracking.roll, selectedAngle: settings.pedalRadians)
                                            .padding()
                                            .rotationEffect(.degrees(180), anchor: .center)
                                    }
                                }
                                
                            }
                            else {
                                //sustain
                                HStack{
                                    Text("Sustain")
                                        .font(.system(size: 30))
                                    Toggle(isOn: $settings.sustainToggleOn,
                                           label: {
                                        Text("")
                                    })
                                }
                                HStack{
                                    Text("Tilt Direction: ") + Text(settings.sustainDirection)
                                    Spacer()
                                    Button(action: switchSustainSostenuto) {
                                        Text("Switch").foregroundStyle(.green)
                                    }
                                    .buttonStyle(.bordered)
                                }
                                
                                Toggle(isOn: $settings.sustainToggleInverse,
                                       label: {
                                    Text("Toggle Pedal Inverse")
                                })
                                
                                VStack(spacing:20){Text("Tilt Trigger Angle")
                                    Slider(value: $settings.sustainAngle,
                                           in: rollMin...rollMax,
                                           step: 0.5
                                    ){Text("Angle")
                                    }minimumValueLabel: {
                                        Text(String(rollMin))
                                    }maximumValueLabel: {
                                        Text(String(rollMax))
                                    }onEditingChanged: { editing in
                                        isSustainEditing = editing
                                    }
                                    .onChange(of: settings.sustainAngle, perform:{angle in
                                        self.degToRad(angle: settings.sustainAngle, pedalName: "sustain", direction: settings.sustainDirection)
                                    })
                                    Text(String(settings.sustainAngle) + "° ")
                                        .foregroundColor(isSustainEditing ? .blue : .white)
                                }
                                Spacer()
                                    .frame(height: 40)
                                TiltAngleBar1PRoll(tiltAngle: faceTracking.roll, selectedAngle: settings.sustainRadians)
                                    .padding()
                                    .rotationEffect(.degrees(180), anchor: .center)
                                Spacer().frame(height: 30)
                                
                                //sostenuto
                                HStack{
                                    Text("Sostenuto").font(.system(size: 30))
                                    Toggle(isOn: $settings.sostenutoToggleOn,
                                           label: {
                                        Text("")
                                    })
                                }
                                HStack{
                                    Text("Tilt Direction: ") + Text(settings.sostenutoDirection)
                                    Spacer()
                                    Button(action: switchSustainSostenuto) {
                                        Text("Switch").foregroundStyle(.green)
                                    }
                                    .buttonStyle(.bordered)
                                }
                                Toggle(isOn: $settings.sostenutoToggleInverse,
                                       label: {
                                    Text("Toggle Pedal Inverse")
                                })
                                
                                VStack(spacing:20){Text("Tilt Trigger Angle")
                                    Slider(value: $settings.sostenutoAngle,
                                           in: rollMin...rollMax,
                                           step: 0.5
                                    ){Text("Angle")
                                    }minimumValueLabel: {
                                        Text(String(rollMin))
                                    }maximumValueLabel: {
                                        Text(String(rollMax))
                                    }onEditingChanged: { editing in
                                        isSostenutoEditing = editing
                                    }
                                    .onChange(of: settings.sostenutoAngle, perform:{angle in
                                        self.degToRad(angle: settings.sostenutoAngle, pedalName: "sostenuto", direction: settings.sostenutoDirection)
                                    })
                                    Text(String(settings.sostenutoAngle) + "° ")
                                        .foregroundColor(isSostenutoEditing ? .blue : .white)
                                }
                                Spacer()
                                    .frame(height: 40)
                                TiltAngleBar1PRoll(tiltAngle: faceTracking.roll, selectedAngle: settings.sostenutoRadians)
                                    .padding()
                                    .rotationEffect(.degrees(180), anchor: .center)
                                Spacer()
                                    .frame(height: 30)
                                
                                //soft
                                
                                HStack{
                                    Text("Soft")
                                        .font(.system(size: 30))
                                    Toggle(isOn: $settings.softToggleOn,
                                           label: {
                                        Text("")
                                    })
                                }
                                HStack{
                                    Text("Tilt Direction: ") + Text(settings.softDirection)
                                    Spacer()
                                }
                                Toggle(isOn: $settings.softToggleInverse,
                                       label: {
                                    Text("Toggle Pedal Inverse")
                                })
                                
                                VStack(spacing:20){Text("Tilt Trigger Angle")
                                    Slider(value: $settings.softAngle,
                                           in: pitchMin...pitchMax,
                                           step: 0.5
                                    ){Text("Angle")
                                    }minimumValueLabel: {
                                        Text(String(pitchMin))
                                    }maximumValueLabel: {
                                        Text(String(pitchMax))
                                    }onEditingChanged: { editing in
                                        isSoftEditing = editing
                                    }
                                    .onChange(of: settings.softAngle, perform:{angle in
                                        self.degToRad(angle: settings.softAngle, pedalName: "soft", direction: settings.softDirection)
                                    })
                                    Text(String(settings.softAngle) + "° ")
                                        .foregroundColor(isSoftEditing ? .blue : .white)
                                    TiltAngleBarPitch(tiltAngle: faceTracking.pitch, selectedAngle: settings.softRadians)
                                        .frame(height: 150)
                                        .padding()
                                        .offset(x: (geometry.size.width / 2) - 80)
                                        
                                }
                            }
                        }
                    }
                }
                .navigationTitle("Settings")
                .onAppear {
                    faceTracking.startSession()
                }
                .onDisappear {
                    faceTracking.stopSession()
                }
            }
        }
    }
}


