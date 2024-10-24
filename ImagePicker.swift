//
//  ImagePicker.swift
//  Saga
//
//  Created by Stavan Gandhi on 6/23/22.
//

import SwiftUI

struct PhotoPicker: UIViewControllerRepresentable{
    @Binding var image: UIImage
    @State var allowsEditing: Bool = false
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.allowsEditing = self.allowsEditing
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(photoPicker: self)
    }
    
    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
        
        let photoPicker: PhotoPicker
        init(photoPicker: PhotoPicker){
            self.photoPicker = photoPicker
        }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if photoPicker.allowsEditing{
                if let img = info[.editedImage] as? UIImage{
                    photoPicker.image = img
                }
            } else{
                if let img = info[.originalImage] as? UIImage{
                    photoPicker.image = img
                }
            }
            picker.dismiss(animated: true)
        }
    }
}
