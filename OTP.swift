//
//  OTP.swift
//  Saga
//
//  Created by Stavan Gandhi on 8/25/22.
//

import SwiftUI



class OTPViewModel: ObservableObject{
    @Published var code: [String] = []
    
    private let grid = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    func UI() -> some View{ self.Screen() }
}


extension OTPViewModel{
    private func Screen() -> some View{
        VStack{
            VStack{
                self.header()
                self.subHeader()
            }
            .padding(.vertical)
            self.codeUI()
            Spacer()
            self.KeyBoard()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func header() -> some View{
        Text("Enter Verification Code")
            .font(.system(.headline, design: .rounded))
            .fontWeight(.bold)
            .frame(width: CGFloat(screenWidth()), alignment: .center)
            .multilineTextAlignment(.center)
            .padding()
            .foregroundColor(Color.Default)
    }
    
    private func subHeader() -> some View{
        Text("You'll receive 4 digit verification code on your email address!")
            .font(.system(.caption, design: .rounded))
            .frame(width: CGFloat(screenWidth()), alignment: .center)
            .multilineTextAlignment(.center)
            .padding()
            .foregroundColor(Color.Default)         
    }
    
    private func codeUI() -> some View{
        VStack{
            HStack{
                ForEach((0...3), id: \.self) { bubbleCount in
                    Rectangle()
                        .fill(Color.DefaultAlter.opacity(0))
                        .frame(width: CGFloat(screenWidth()/6), height: CGFloat(screenWidth()/6), alignment: .center)
                        .overlay {
                            if self.code.count > bubbleCount{
                                Text("\(self.code[bubbleCount])")
                                    .foregroundColor(Color.Default)
                            }
                        }
                        .overlay(alignment: .bottom) {
                            Image(systemName: "line.diagonal")
                                .rotationEffect(Angle(degrees: 45))
                                .frame(width: CGFloat(screenWidth()/6), alignment: .center)
                        }
                }
            }
        }
    }
    
    private func KeyBoard() -> some View{
        VStack{
            LazyVGrid(columns: grid) {
                ForEach((1...9), id: \.self) { text in
                    Button(action: {
                        Haptics()
                        if (self.code.count<4) {
                            self.code.append(String(describing: text))
                        }
                    }) {
                        Text("\(text)")
                            .passcodeBtn()
                    }
                }
            }
            LazyVGrid(columns: grid) {
                ClearBtn()
                Button(action: {
                    Haptics()
                    if (self.code.count<4) {
                        self.code.append("0")
                    }
                }) {
                    Text("\(0)")
                        .passcodeBtn()
                }
                DeleteBtn()
            }
        }
        .padding(.horizontal)
    }
    
    private func ClearBtn() -> some View{
        Button(action: {
            Haptics()
            self.code.removeAll()
        }) {
            Image(systemName: "paintbrush")
                .passcodeBtn()
        }
    }
    
    private func DeleteBtn() -> some View{
        Button(action: {
            Haptics()
            if self.code.count != 0 {
                self.code.removeLast()
            }
        }) {
            Image(systemName: "delete.left")
                .passcodeBtn()
        }
    }
}
