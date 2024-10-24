//
//  Extensions.swift
//  Saga
//
//  Created by Stavan Gandhi on 6/16/22.
//

import SwiftUI

extension String {
    func replace(string:String, replacement:String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }
    
    func removeWhitespace() -> String {
        return self.replace(string: " ", replacement: "")
    }
    
    func removeNewLine() -> String {
        return self.replace(string: "\n", replacement: "")
    }
    
    func findHashTag(removeHash: Bool = false) -> [String] {
        var arr_hasStrings:[String] = []
        var hashTag:[String] = []
        let regex = try? NSRegularExpression(pattern: "(#[a-zA-Z0-9_\\p{Arabic}\\p{N}]*)", options: [])
        if let matches = regex?.matches(in: self, options:[], range:NSMakeRange(0, self.count)) {
            for match in matches {
                arr_hasStrings.append(NSString(string: self).substring(with: NSRange(location:match.range.location, length: match.range.length )))
            }
        }
        
        for tag in arr_hasStrings {
            if tag.count > 3{
                if !hashTag.contains(tag){
                    if removeHash{
                        hashTag.append(tag.replace(string: "#", replacement: ""))
                    }
                    else{
                        hashTag.append(tag)
                    }
                }
            }
        }
    
        return hashTag
    }

    func createURL() -> String{
        return self.replacingOccurrences(of: " ", with: "%20")
    }
}



#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif


class ImageSaver: NSObject {
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }

    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print("Save finished!")
    }
}

