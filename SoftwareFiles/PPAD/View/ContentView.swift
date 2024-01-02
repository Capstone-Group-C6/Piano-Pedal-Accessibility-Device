//
//  ContentView.swift
//  PPAD
//
//  Created by Roberto Chadwick on 11/27/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var settings = Settings()
    @State var isConnected :Bool = true
    @State var showSettings: Bool = false
    @State var showBluetooth: Bool = false
    @State var showSession: Bool = false
    
    @ObservedObject var faceTracking = FaceTracking()
    var bleServer = BLEServer()
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer().frame(height: 20)
                HStack{
                    Button{
                        showBluetooth.toggle()
                    }label:{
                        Image(systemName:"antenna.radiowaves.left.and.right").resizable().frame(width:30.0, height:30.0).tint(.gray)
                    }.navigationDestination(isPresented: $showBluetooth){BluetoothView()}
                    Spacer().frame(width: 230)
                    Button{
                        showSettings.toggle()
                    }label:{
                        Image(systemName:"slider.horizontal.3").resizable().frame(width:30.0, height:30.0).tint(.gray)
                    }.navigationDestination(isPresented: $showSettings){SettingsView(faceTracking: faceTracking)}
                }
                Spacer()
                Image(.piano).resizable().frame(width:350.0, height:300.0)
                    .padding()
                Spacer()
                Text("Start Session").foregroundStyle(.white)
                Button{
                    showSession.toggle()
                }label:{
                    Image(systemName:"pianokeys")
                        .resizable().frame(width:100.0, height:80.0)
                        .tint(.gray)
                }
                .navigationDestination(isPresented: $showSession){
                    if settings.sustainDirection == "Right" {
                        SessionView(faceTracking: faceTracking, bleServer: bleServer, 
                                    soloPedal: Pedal(inverse: settings.sustainToggleInverse, angle: settings.pedalRadians, type: 2, hold: settings.sustainToggleHold, state: true),
                                    rightPedal: Pedal(inverse: settings.sustainToggleInverse, angle: settings.sustainRadians, type: 2, hold: settings.sustainToggleHold, state: settings.sustainToggleOn),
                                    leftPedal: Pedal(inverse: settings.sostenutoToggleInverse, angle: settings.sostenutoRadians, type: 1, hold: false, state: settings.sostenutoToggleOn),
                                    midPedal: Pedal(inverse: settings.softToggleInverse, angle: settings.softRadians, type: 0, hold: false, state: settings.softToggleOn))
                    } else {
                        SessionView(faceTracking: faceTracking, bleServer: bleServer, 
                                    soloPedal: Pedal(inverse: settings.sustainToggleInverse, angle: settings.pedalRadians, type: 2, hold: settings.sustainToggleHold, state: true),
                                    rightPedal: Pedal(inverse: settings.sostenutoToggleInverse, angle: settings.sostenutoRadians, type: 1, hold: false, state: settings.sostenutoToggleOn),
                                    leftPedal: Pedal(inverse: settings.sustainToggleInverse, angle: settings.sustainRadians, type: 2, hold: settings.sustainToggleHold, state: settings.sustainToggleOn),
                                    midPedal: Pedal(inverse: settings.softToggleInverse, angle: settings.softRadians, type: 0, hold: false, state: settings.softToggleOn))
                    }
                }
                .disabled(!isConnected)
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ContentView()
}
