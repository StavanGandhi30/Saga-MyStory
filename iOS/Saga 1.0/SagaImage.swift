//
//  SagaImage.swift
//  Saga
//
//  Created by Stavan Gandhi on 8/9/22.
//

import SwiftUI

class SagaImage: ObservableObject{
    @Published var image: UIImage? = nil
    @Published var result: ImageStatus = .processing
    
    private let urlImageDownloader = URLImageDownloader.instance
    private let fileManager = LocalFileManager.instance
    
    private var imageURL: URL?
    private var imageName: String?
    private var folderName: String?
    
    init(_ imageURL: URL, imageName:String, folderName: String){
        self.imageURL = imageURL
        self.imageName = imageName
        self.folderName = folderName
        self.getImage()
    }
    
    func getImage(){
        guard let imageURL = imageURL, let imageName = imageName, let folderName = folderName else{
            return
        }
        
        if let savedImage = fileManager.getImage(imageName: imageName, folderName: folderName) {
            self.image = savedImage
            self.result = .success
        } else {
            self.urlImageDownloader.downloadimg(imageURL, imageName: imageName, folderName: folderName) { img in
                guard let savedImage = img else{
                    self.image = nil
                    self.result = .fail
                    return
                }

                self.image = savedImage
                self.result = .success
            }
        }
    }
}


enum ImageStatus{
    case success, fail, processing
}
