//
//  SixWordsMemoir.swift
//  Saga
//
//  Created by Stavan Gandhi on 7/31/22.
//

import SwiftUI

struct addSixWordsMemoir : View {
    @Binding var showTempleteSheet: Bool
    @Binding var string: String
    @Binding var sixWordMemiorWords: [String]
    
    var body: some View{
        HStack{
            VStack{
                Text("Six Words Memoir")
                    .fontWeight(.medium)
                    .font(.system(.headline, design: .rounded))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Six Words Memoir is a story told in only in six words. Can you write about your day in only six words.")
                    .multilineTextAlignment(.leading)
                    .opacity(0.5)
                    .font(.system(.subheadline, design: .rounded))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            Image(systemName: "ellipsis")
                .rotationEffect(Angle(degrees: 90))
        }
        .padding(.vertical)
        .overlay(
            addSixWordsMemoirView(showTempleteSheet: $showTempleteSheet, string: $string, sixWordMemiorWords: $sixWordMemiorWords)
        )
    }
}

struct addSixWordsMemoirView: View{
    @Binding var showTempleteSheet: Bool
    @Binding var string: String
    @Binding var sixWordMemiorWords: [String]
    
    var body: some View{
        NavigationLink(
            destination: {
                List{
                    Section(header: Text("Six Words Memoir:")){
                        TextField("", text: $sixWordMemiorWords[0])
                            .onChange(of: sixWordMemiorWords[0], perform: { value in
                                sixWordMemiorWords[0] = sixWordMemiorWords[0].removeWhitespace()
                            })
                        TextField("", text: $sixWordMemiorWords[1])
                            .onChange(of: sixWordMemiorWords[1], perform: { value in
                                sixWordMemiorWords[1] = sixWordMemiorWords[1].removeWhitespace()
                            })
                        TextField("", text: $sixWordMemiorWords[2])
                            .onChange(of: sixWordMemiorWords[2], perform: { value in
                                sixWordMemiorWords[2] = sixWordMemiorWords[2].removeWhitespace()
                            })
                        TextField("", text: $sixWordMemiorWords[3])
                            .onChange(of: sixWordMemiorWords[3], perform: { value in
                                sixWordMemiorWords[3] = sixWordMemiorWords[3].removeWhitespace()
                            })
                        TextField("", text: $sixWordMemiorWords[4])
                            .onChange(of: sixWordMemiorWords[4], perform: { value in
                                sixWordMemiorWords[4] = sixWordMemiorWords[4].removeWhitespace()
                            })
                        TextField("", text: $sixWordMemiorWords[5])
                            .onChange(of: sixWordMemiorWords[5], perform: { value in
                                sixWordMemiorWords[5] = sixWordMemiorWords[5].removeWhitespace()
                            })
                    }
                }
                .interactiveDismissDisabled()
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            string = "\(string)\nSix Words Memoir: \(sixWordMemiorWords[0]) \(sixWordMemiorWords[1]) \(sixWordMemiorWords[2]) \(sixWordMemiorWords[3]) \(sixWordMemiorWords[4]) \(sixWordMemiorWords[5])\n"
                            showTempleteSheet.toggle()
                        }) {
                            Image(systemName: "hand.tap")
                        }
                    }
                }
            }
            
        ){
            EmptyView()
        }.opacity(0)
    }
}

