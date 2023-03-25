//
//  ImageTab.swift
//  Saga
//
//  Created by Stavan Gandhi on 7/15/22.
//

import SwiftUI
import FirebaseStorage

struct ImageView: View {
    @StateObject var journalData: JournalDataManager
    @StateObject var imageModel = ImageTabViewModel()
    @State private var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        VStack{
            ScrollView{
                LazyVGrid(columns: gridItemLayout) {
                    ForEach(imageModel.imagesURL, id: \.id) { eachImageModel in
                        fetchEachImages(model: eachImageModel)
                    }
                }
            }
        }
        .navigationTitle("Image")
        .navigationBarTitleDisplayMode(.large)
        .onAppear{
            imageModel.Reload(journalData: journalData)
        }
    }
}


private struct fetchEachImages: View{
    @StateObject var vm: SagaImage
    
    init(model: ImageTabVMType) {
        _vm = StateObject(wrappedValue: SagaImage(model.imagesURL, imageName: model.imageName, folderName: String(describing: model.post.documentID)))
    }
    
    var body: some View{
        if vm.result == .success{
            NavigationLink(destination: {
                FullScreenImage(image: vm.image!)
            }) {
                Image(uiImage: vm.image!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: CGFloat(screenWidth())/2, height: CGFloat(screenWidth())/2)
            }
        } else{
            ProgressView()
                .frame(width: CGFloat(screenWidth())/2.5, height: CGFloat(screenWidth())/2.5)
        }
    }
}

struct FullScreenImage: View{
    var image: UIImage
    @State private var scale: CGFloat = 1
    @State private var showShareSheet : Bool = false
    
    var body: some View{
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .zoomable(scale: $scale, minScale: 1)
            .padding()
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showShareSheet.toggle()
                    }) {
                        Image(systemName: "square.and.arrow.down")
                    }
                }
            }
            .sheet(isPresented: $showShareSheet) {
                ShareSheet(activityItems: [self.image])
            }
    }
}
