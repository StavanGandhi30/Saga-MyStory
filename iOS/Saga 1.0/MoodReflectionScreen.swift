//
//  MoodReflectionScreen.swift
//  Saga
//
//  Created by Stavan Gandhi on 6/21/22.
//

import SwiftUI

struct MoodReflectionScreen: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var emojiName: [String] = getEmojiNames()
    @State private var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible())]
    
    @StateObject var JournalScreenVM: JournalScreenViewModel
    @State private var selection: [String] = []
    
    var body: some View {
        ScrollView{
            LazyVGrid(columns: gridItemLayout){
                ForEach(getEmojiNames(), id:\.self){ eachEmoji in
                    Image(eachEmoji)
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width/3, alignment: .center)
                        .clipped()
                        .padding()
                        .opacity(selection.contains(eachEmoji) ? 1.0 : 0.5)
                        .onTapGesture {
                            if selection.contains(eachEmoji){
                                if let index = selection.firstIndex(of: eachEmoji) {
                                    selection.remove(at: index)
                                }
                            } else{
                                selection.append(eachEmoji)
                            }
                        }
                }
            }
        }
        .navigationTitle("Emoji")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear{
            if JournalScreenVM.emoji != nil{
                selection = JournalScreenVM.emoji!
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action:{
                    JournalScreenVM.emoji = []
                    for each in selection{
                        JournalScreenVM.emoji?.append(each)
                    }
                    presentationMode.wrappedValue.dismiss()
                }){
                    Image(systemName: "hand.tap")
                }
            }
        }
    }
}


extension Image{
    func emojiBtn() -> some View{
        self.resizable()
            .scaledToFit()
            .frame(width: CGFloat(screenWidth())/4, height: CGFloat(screenHeight())/4)
            .clipped()
            .shadow(color: Color.Theme, radius: 30)
            .padding()
    }
}


func getEmojiNames() -> [String]{
    return [
        "Angry",
        "Furious",
        "Upset",
        "Sad",
        "Anxious",
        "Neutral",
        "Grateful",
        "Lucky",
        "Loved",
        "Entertained"
    ]
}
