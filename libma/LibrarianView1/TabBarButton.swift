//
//  TabBarButton.swift
//  libma
//
//  Created by Yuvraj Pandey on 29/04/24.
//

import SwiftUI

struct TabBarButton: View {
    let imageName: String
    let text: String
    let index: Int
    @Binding var selectedIndex: Int
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(selectedIndex == index ? Color(hex: 0x54408C) : Color.clear)
                .frame(width: selectedIndex == index ? 118 : 0, height: 90)
                .cornerRadius(10)
            
            Button(action: {
                self.selectedIndex = index
            }) {
                VStack (spacing: 15) {
                    Image(systemName: imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 35, height: 35)
                        .foregroundColor(selectedIndex == index ? .white : .black)
                    
                    Text(text)
                        .font(
                            Font.custom("SF Pro", size: 15)
                                .weight(.bold)
                        )
                        .foregroundColor(selectedIndex == index ? .white : .black)
                        .frame(width: 150)
                }
                .padding()
            }
        }
        .cornerRadius(10)
    }
}
