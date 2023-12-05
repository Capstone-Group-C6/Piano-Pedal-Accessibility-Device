//
//  SettingsObjects.swift
//  PPAD
//
//  Created by Roberto Chadwick on 11/27/23.
//

import SwiftUI

//CHANGE STARTER VALUES FOR ANGLES

class Settings: ObservableObject {
    @AppStorage("threePedal") var threePedal: Bool = false
    @AppStorage("rightAngle") var rightAngle = 20.0
    @AppStorage("leftAngle") var leftAngle = 20.0
    @AppStorage("downAngle") var downAngle = 10.0
    @AppStorage("pedalNumSelection") var pedalNumSelection = "1 Pedal"
    @AppStorage("pedalDirection") var pedalDirection = "Right"
    @AppStorage("pedalAngle") var pedalAngle = 20.0
    @AppStorage("pedalRadians") var pedalRadians = 1.9
    @AppStorage("bothAngle") var bothAngle = 20.0
    @AppStorage("bothRadians") var bothRadians = 1.22
    @AppStorage("actuationDelay") var actuationDelay = 50
    
    //pedal specific settings
    @AppStorage("sustainToggleOn") var sustainToggleOn :Bool = true
    @AppStorage("sustainToggleHold") var sustainToggleHold :Bool = false
    @AppStorage("sustainToggleInverse") var sustainToggleInverse :Bool = false
    @AppStorage("sustainDirection") var sustainDirection = "Right"
    @AppStorage("sustainAngle") var sustainAngle = 20.0
    @AppStorage("sustainRadians") var sustainRadians = 1.9
    @AppStorage("sostenutoToggleOn") var sostenutoToggleOn :Bool = true
    @AppStorage("sostenutoToggleInverse") var sostenutoToggleInverse :Bool = false
    @AppStorage("sostenutoDirection") var sostenutoDirection = "Left"
    @AppStorage("sostenutoAngle") var sostenutoAngle = 20.0
    @AppStorage("sostenutoRadians") var sostenutoRadians = 1.22
    @AppStorage("softToggleOn") var softToggleOn :Bool = true
    @AppStorage("softToggleInverse") var softToggleInverse :Bool = false
    @AppStorage("softDirection") var softDirection = "Down"
    @AppStorage("softAngle") var softAngle = 10.0
    @AppStorage("softRadians") var softRadians = 0.175
}
