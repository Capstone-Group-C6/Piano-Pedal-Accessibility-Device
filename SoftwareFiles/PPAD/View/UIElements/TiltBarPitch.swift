//
//  TiltBarPitch.swift
//  PPAD
//
//  Created by Mr.Jos on 12/3/23.
//

import SwiftUI

struct TiltAngleBarPitch: View {
    var tiltAngle: Double
    var selectedAngle: Double
    let topPoint: Double = 0
    
    let minAngle = -20 * Double.pi / 180 // -20 degrees in radians
    let maxAngle = 40 * Double.pi / 180 // 40 degrees in radians

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background bar with outline
                Rectangle()
                    .stroke(lineWidth: 6)
                    .background(Rectangle().fill(Color.gray))
                    .frame(width: 40, height: geometry.size.height + 6)
                    .cornerRadius(5)

                // Bottom filling rectangle
                Rectangle()
                    .fill(Color.green.opacity(0.9))
                    .frame(width: 34, height: geometry.size.height * self.topFillRatio())
                    .offset(y: -geometry.size.height * (1 - self.topFillRatio()) / 2)


                Rectangle()
                    .fill(Color.white)
                    .frame(width: 60, height: 3)
                    .offset(y: self.arrowOffset(for: geometry.size.height, at: selectedAngle))
            }
        }
    }

    private func topFillRatio() -> CGFloat {
        let normalizedTilt = (tiltAngle - minAngle) / (maxAngle - minAngle)
        return CGFloat(max(0, min(1, normalizedTilt))) // Ensures the ratio is between 0 and 1
    }

    private func arrowOffset(for totalHeight: CGFloat, at angle: Double) -> CGFloat {
        let normalizedAngle = (angle - minAngle) / (maxAngle - minAngle)
        return -(totalHeight * (1 - CGFloat(normalizedAngle)) - totalHeight / 2)
    }
}
