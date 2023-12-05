//
//  TiltAngleBarBoth.swift
//  PPAD
//
//  Created by Luke on 11/28/23.
//

import SwiftUI

struct TiltAngleBarBoth: View {
    var tiltAngle: Double
    var selectedLeftAngle: Double
    var selectedRightAngle: Double
    let centerPoint: Double = Double.pi / 2

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background bar with outline
                Rectangle()
                    .stroke(lineWidth: 6)
                    .background(Rectangle().fill(Color.gray))
                    .frame(width: geometry.size.width + 6, height: 40)
                    .cornerRadius(5)

                HStack(spacing: 0) {
                    // Left filling rectangle
                    Rectangle()
                        .fill(Color.green.opacity(0.9))
                        .frame(width: geometry.size.width * self.leftFillRatio() / 2, height: 34)
                        .offset(x: self.leftBarOffset(for: geometry.size.width), y: 0)

                    // Right filling rectangle
                    Rectangle()
                        .fill(Color.green.opacity(0.9))
                        .frame(width: geometry.size.width * self.rightFillRatio() / 2, height: 34)
                        .offset(x: self.rightBarOffset(for: geometry.size.width), y: 0)
                }
                
                Rectangle()
                    .fill(Color.white)
                    .frame(width: 3, height: 34)
                
                Rectangle()
                    .fill(Color.white)
                    .frame(width: 3, height: 60)
                    .offset(x: self.arrowLeftOffset(for: geometry.size.width, at: selectedLeftAngle))
                Rectangle()
                    .fill(Color.white)
                    .frame(width: 3, height: 60)
                    .offset(x: self.arrowLeftOffset(for: geometry.size.width, at: selectedRightAngle))
            }
        }
    }

    private func rightFillRatio() -> CGFloat {
        if tiltAngle >= centerPoint {
            return 0 // No fill when tiltAngle is center or rightward
        } else {
            if tiltAngle <= (centerPoint - (45 * Double.pi / 180)) {
                return CGFloat((centerPoint - (centerPoint - (45 * Double.pi / 180))) / (45 * Double.pi / 180))
            } else {
                // Fill ratio grows as tiltAngle moves left from the center
                return CGFloat((centerPoint - tiltAngle) / (45 * Double.pi / 180))
            }
        }
    }

    private func leftFillRatio() -> CGFloat {
        if tiltAngle <= centerPoint {
            return 0 // No fill when tiltAngle is center or leftward
        } else {
            if tiltAngle >= (centerPoint + (45 * Double.pi / 180)) {
                return CGFloat(((centerPoint + (45 * Double.pi / 180)) - centerPoint) / (45 * Double.pi / 180))
            } else {
                // Fill ratio grows as tiltAngle moves right from the center
                return CGFloat((tiltAngle - centerPoint) / (45 * Double.pi / 180))
            }
        }
    }

    private func leftBarOffset(for totalWidth: CGFloat) -> CGFloat {
        let leftBarWidth = totalWidth * self.leftFillRatio() / 2
        return -leftBarWidth / 2
    }

    private func rightBarOffset(for totalWidth: CGFloat) -> CGFloat {
        let rightBarWidth = totalWidth * self.rightFillRatio() / 2
        return rightBarWidth / 2
    }
    
    private func arrowLeftOffset(for totalWidth: CGFloat, at angle: Double) -> CGFloat {
        let normalizedAngle = (centerPoint + (45 * Double.pi / 180) - angle) / (2 * (45 * Double.pi / 180))
        return totalWidth * normalizedAngle - totalWidth / 2
    }
}
