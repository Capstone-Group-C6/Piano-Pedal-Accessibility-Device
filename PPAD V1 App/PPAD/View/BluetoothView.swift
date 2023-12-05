//
//  SessionView.swift
//  PPAD
//
//  Created by Roberto Chadwick on 11/27/23.
//

import SwiftUI

struct BluetoothView: View {
    var body: some View {
        VStack {
            Text("Connection Settings").font(.system(size: 28))
            Spacer().frame(height:60)
            Text("To connect, press the reset button on the device when the app is open").font(.system(size: 18)).frame(width:350)
            Spacer().frame(height:30)
            HStack {
                Text("For best head tracking results, orient the phone vertically and prop it up at straight angle").font(.system(size: 18))
                Image(systemName:"arrow.turn.up.forward.iphone").resizable().frame(width:70.0, height:60.0).tint(.gray).padding()
            }.frame(width:350)
            Spacer()
        }
        .padding()
    }
}
