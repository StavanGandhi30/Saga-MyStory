//
//  ImageDownloader.swift
//  Saga
//
//  Created by Stavan Gandhi on 8/9/22.
//

import SwiftUI

class URLImageDownloader{
    static let instance = URLImageDownloader()
    let fileManager = LocalFileManager.instance
    
    func downloadimg(_ ImageURL: URL, imageName: String, folderName: String, completion: @escaping (UIImage?) -> Void){
        // Create Data Task
        let dataTask = URLSession.shared.dataTask(with: ImageURL) { [weak self] (data, response, error)  in
            if let error = error {
//                print("Error while downloading Image: \(error)")
                completion(nil)
            }
            if let data = data {
                // Create Image and Update Image View
                self?.fileManager.saveImage(image: UIImage(data: data)!, imageName: imageName, folderName: folderName)
                completion(UIImage(data: data)!)
//                print("done")
            }
        }
        
        // Start Data Task
        dataTask.resume()
    }
}
