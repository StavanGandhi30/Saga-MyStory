//
//  AddImgScreen.swift
//  Saga
//
//  Created by Stavan Gandhi on 6/23/22.
//

import SwiftUI

struct AddImgScreen: View {
    @Binding var userImageList: [UIImage]
    @State var isShowingPhotoPicker: Bool = false
    @State var userImage = UIImage()
    @State private var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible())]
    @State var isShowingFullScreen: Bool = false
    
    var body: some View {
        VStack{
            ScrollView {
                LazyVGrid(columns: gridItemLayout) {
                    ForEach(Array(zip(self.userImageList.indices, self.userImageList)), id: \.0) { index, img in
                        NavigationLink(destination: {
                            AddImgScreenFullView(userImageList: $userImageList, index: index, isShowingFullScreen: $isShowingFullScreen)
                        }) {
                            Image(uiImage: img)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: CGFloat(screenWidth())/2.5, height: CGFloat(screenWidth())/2.5)
                                .padding()
                        }
                    }
                    if userImageList.count < 4 {
                        addBtn
                    }
                }
            }
        }
        .padding()
        .navigationTitle("Image")
        .edgesIgnoringSafeArea(.bottom)
    }
    
    var addBtn: some View {
        Image(systemName: "plus")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .padding()
            .frame(width: CGFloat(screenWidth()/6), height: CGFloat(screenWidth()/6), alignment: .center)
            .padding()
            .foregroundColor(Color.Theme)
            .onTapGesture{
                self.isShowingPhotoPicker = true
            }
            .sheet(isPresented: $isShowingPhotoPicker){
                PhotoPicker(image: $userImage)
            }
            .onChange(of: userImage, perform: { img in
                if userImageList.count < 4{
                    userImageList.append(userImage)
                }
            })
    }
}


struct AddImgScreenFullView: View{
    @Environment(\.presentationMode) var presentationMode
    
    @State private var scale: CGFloat = 1
    @Binding var userImageList: [UIImage]
    @State var index: Int = 0
    @Binding var isShowingFullScreen: Bool
    
    var body: some View{
        VStack{
            if self.userImageList.count > index {
                Image(uiImage: self.userImageList[index])
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .zoomable(scale: $scale, minScale: 1)
                    .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .padding()
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                    self.userImageList.remove(at: index)
                }) {
                    Image(systemName: "minus")
                }
            }
        }
    }
}


//struct AddImgScreen: View {
//    @Binding var userImageList: [UIImage]
//    @State var isShowingPhotoPicker: Bool = false
//    @State var userImage = UIImage()
//
//    var body: some View {
//        VStack{
//            if userImageList.count == 0{
//                Spacer()
//                Image(systemName: "photo")
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .padding()
//                Spacer()
//            } else{
//                TabView {
//                    ForEach(userImageList.reversed(), id: \.self) { img in
//                        Image(uiImage: img)
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .padding()
//                    }
//                }
//                .tabViewStyle(.page)
//                .indexViewStyle(.page(backgroundDisplayMode: .always))
//                .padding(.vertical)
//            }
//        }
//        .navigationTitle("Image")
//        .navigationBarTitleDisplayMode(.inline)
//        .toolbar {
//            ToolbarItem(placement: .navigationBarTrailing) {
//                Button(action:{
//                    isShowingPhotoPicker = true
//                }){
//                    Image(systemName: "plus")
//                }
//            }
//        }
//        .edgesIgnoringSafeArea(.bottom)
//
//        .sheet(isPresented: $isShowingPhotoPicker){
//            PhotoPicker(image: $userImage)
//        }
//        .onChange(of: userImage, perform: { img in
//            if userImageList.count < 4{
//                userImageList.append(userImage)
//            }
//        })
//    }
//}
