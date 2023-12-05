//
//  PedalIndicator.swift
//  PPAD
//
//  Created by Mr.Jos on 12/2/23.
//

import SwiftUI

struct PedalIndicator: View {
    var threePedal: Bool
    var onePedal: Bool
    var rightPedal: Bool
    var leftPedal: Bool
    var middlePedal: Bool
    
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.gray.opacity(0.4))
                .frame(height: 90)
                .cornerRadius(10)
            
            if threePedal {
                HStack(spacing: 0){
                    UnevenRoundedRectangle(cornerRadii: .init(topLeading: 10, bottomLeading: 10))
                        .stroke(lineWidth: 6)
                        .fill(Color.white)
                        .background(Rectangle().foregroundColor(leftPedal ? Color.green : Color.gray))
                        .frame(width: 100, height: 50)
                    Rectangle()
                        .stroke(lineWidth: 6)
                        .fill(Color.white)
                        .background(Rectangle().foregroundColor(middlePedal ? Color.green : Color.gray))
                        .frame(width: 100, height: 50)
                    UnevenRoundedRectangle(cornerRadii: .init(bottomTrailing: 10, topTrailing: 10))
                        .stroke(lineWidth: 6)
                        .fill(Color.white)
                        .background(Rectangle().foregroundColor(rightPedal ? Color.green : Color.gray))
                        .frame(width: 100, height: 50)
                }.padding()
            }
            else{
                RoundedRectangle(cornerRadius: 10.0)
                    .frame(width: 300, height: 50)
                    .foregroundColor(onePedal ? Color.green : Color.gray)
                    .padding()
            }
        }
    }

}

