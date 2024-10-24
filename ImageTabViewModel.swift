//
//  ImageTabViewModel.swift
//  Saga
//
//  Created by Stavan Gandhi on 8/9/22.
//

import SwiftUI

struct ImageTabVMType: Identifiable {
    var id: String = UUID().uuidString
    
    var imagesURL: URL
    var imageName: String
    var post: JournalDataType
}


class ImageTabViewModel: ObservableObject {
    @Published var imagesURL = [ImageTabVMType]()
    
    func fetchImagesURL(journalData: JournalDataManager){
        DispatchQueue.main.async {
            for each in journalData.JournalDataVar {
                for (index, eachUrl) in each.ImageURL.enumerated(){
                    self.imagesURL.append(
                        ImageTabVMType(
                            imagesURL: FirebaseImageURL(url: eachUrl),
                            imageName: "\(index)",
                            post: each
                        )
                    )
                }
            }
        }
    }
    
    func Reload(journalData: JournalDataManager){
        self.imagesURL = []
        self.fetchImagesURL(journalData: journalData)
    }
}
