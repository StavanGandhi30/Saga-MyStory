//
//  Passcode.swift
//  Saga
//
//  Created by Stavan Gandhi on 8/18/22.
//

import SwiftUI

class PasscodeViewModel: ObservableObject {
    @Published var code: [String] = []
    @AppStorage("appPasscode") var appPasscode: String = ""
    
    private var storedPasscode: [String] = []
    private var passcodeErrorAttempt: Int = 0
    private let grid = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    private var createPasscodeUILogic: CreatePasscodeUILogic = .createPasscode
    
    func LockScreenUI(_ password: String? = nil, completion: ((Bool) -> Void)? = nil) -> some View{
        Screen("Enter Passcode")
            .onChange(of: self.code, perform: { newValue in
                if self.code.count == 4{
                    if self.storedPasscode == self.code{
                        completion?(true)
                        print("Matched")
                    } else{
                        self.code = []
                        if self.passcodeErrorAttempt > 4{
                            completion?(false)
                        } else{
                            self.passcodeErrorAttempt += 1
                        }
                        print("UnMatched")
                    }
                }
            })
            .onAppear{
                guard let pwd = password else{
                    return
                }
                self.stored(pwd)
            }
    }
    
    func CreatePasscodeUI(completion: (([String]?, Bool) -> Void)? = nil) -> some View{
        VStack{
            switch self.createPasscodeUILogic {
            case .createPasscode:
                self.CreatePasscode()
            case .confirmPasscode:
                self.ConfirmPasscode { passcode, success in
                    completion?(passcode,success)
                }
                .interactiveDismissDisabled()
            }
        }
    }
}

// Login Passcode View
extension PasscodeViewModel{
    func stored(_ passcode: String){
        var array: [String] = []
        for char in passcode{
            array.append(String(describing: char))
        }
        self.storedPasscode = array
    }
}

// Create Passcode View
extension PasscodeViewModel{
    private func CreatePasscode() -> some View{
        Screen("Create Passcode")
            .onChange(of: self.code, perform: { _ in
                if self.code.count == 4{
                    self.storedPasscode = self.code
                    self.code = []
                    self.createPasscodeUILogic = .confirmPasscode
                }
            })
    }
    
    private func ConfirmPasscode(completion: (([String]?,Bool) -> Void)? = nil) -> some View{
        Screen("Confirm Passcode")
            .onChange(of: self.code, perform: { newValue in
                if self.code.count == 4{
                    if self.storedPasscode == self.code{
                        completion?(self.storedPasscode, true)
                        print("Matched")
                    } else{
                        completion?(nil, false)
                        print("UnMatched")
                    }
                }
            })
    }
    
    enum type{
        case create, login
    }
    enum CreatePasscodeUILogic {
        case createPasscode, confirmPasscode
    }
}

// Main Screen View
extension PasscodeViewModel{
    private func Screen(_ title: String) -> some View{
        VStack{
            self.header(title)
            self.codeUI()
            self.KeyBoard()
            self.footer()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func header(_ text: String) -> some View{
        Text(text)
            .font(.system(.body, design: .rounded))
            .frame(width: CGFloat(screenWidth()), alignment: .center)
            .multilineTextAlignment(.center)
            .padding()
            .foregroundColor(Color.Default)
    }
    
    private func codeUI() -> some View{
        VStack{
            HStack{
                ForEach((0...3), id: \.self) { bubbleCount in
                    if self.code.count <= bubbleCount{
                        Circle()
                            .strokeBorder(Color.Default, lineWidth: 1)
                            .frame(width: CGFloat(screenWidth()/28), alignment: .center)
                            .padding()
                    } else{
                        Circle()
                            .fill(Color.Default)
                            .frame(width: CGFloat(screenWidth()/28), alignment: .center)
                            .padding()
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
    
    private func footer() -> some View{
        Text("We keep your account Secured")
            .foregroundColor(Color.Theme)
            .font(.system(.caption, design: .rounded))
            .frame(width: CGFloat(screenWidth()), alignment: .center)
            .multilineTextAlignment(.center)
            .padding()
            .opacity(0.5)
    }
}


// Passcode View Extension
extension Text{
    func passcodeBtn() -> some View{
        self
            .foregroundColor(Color.Default)
            .font(.system(.title3, design: .rounded))
            .frame(width: CGFloat(screenWidth())/12, height: CGFloat(screenHeight())/13, alignment: .center)
            .padding()
            .padding(.horizontal)
    }
}

extension Image{
    func passcodeBtn() -> some View{
        self
            .foregroundColor(Color.Default)
            .font(.title3)
            .frame(width: CGFloat(screenWidth())/12, height: CGFloat(screenHeight())/13, alignment: .center)
            .padding()
            .padding(.horizontal)
    }
}


