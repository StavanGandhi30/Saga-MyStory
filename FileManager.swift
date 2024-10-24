//
//  FileManager.swift
//  Saga
//
//  Created by Stavan Gandhi on 8/8/22.
//

import SwiftUI
import Foundation

class LocalFileManager {
    static let instance = LocalFileManager()
    private let baseURL: String = "Journal"
    
    private init() { }
    
    func saveImage(image: UIImage, imageName: String, folderName: String) {
        
        // create folder
        createFolderIfNeeded(folderName: folderName)
        
        // get path for image
        guard
            let data = image.jpegData(compressionQuality: 0.8),
            let url = getURLForImage(imageName: imageName, folderName: folderName)
            else { return }
        
        // save image to path
        do {
            try data.write(to: url)
//            print("Data written to \(url)")
        } catch let error {
//            print("Error saving image. ImageName: \(imageName). \(error)")
        }
    }
    
    func getImage(imageName: String, folderName: String) -> UIImage? {
//        print("imageName: \(imageName)")
//        print("folderName: \(folderName)")
        guard
            let url = getURLForImage(imageName: imageName, folderName: folderName),
            FileManager.default.fileExists(atPath: url.path) else {
            
//            print("return")
            return nil
        }
//        print("\(url)")
        return UIImage(contentsOfFile: url.path)
    }
    
    func deleteFile(){
        
    }
    
    func clearCache(){
        let cacheURL =  FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let fileManager = FileManager.default
        do {
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try FileManager.default.contentsOfDirectory( at: cacheURL, includingPropertiesForKeys: nil, options: [])
            for file in directoryContents {
                do {
                    try fileManager.removeItem(at: file)
                }
                catch let error as NSError {
//                    debugPrint("Ooops! Something went wrong: \(error)")
                }

            }
        } catch let error as NSError {
//            print(error.localizedDescription)
        }
    }
    
    private func createFolderIfNeeded(folderName: String) {
        guard let url = getURLForFolder(folderName: folderName) else { return }
        
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
//                print("Folder Created at \(folderName).")
            } catch let error {
//                print("Error creating directory. FolderName: \(folderName). \(error)")
            }
        }
    }
    
    private func getURLForFolder(folderName: String) -> URL? {
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        return url.appendingPathComponent(baseURL).appendingPathComponent(folderName)
    }
    
    private func getURLForImage(imageName: String, folderName: String) -> URL? {
        guard let folderURL = getURLForFolder(folderName: folderName) else {
            return nil
        }
        return folderURL.appendingPathComponent(imageName + ".jpeg")
    }
    
}
