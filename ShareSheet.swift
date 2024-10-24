//
//  ShareSheet.swift
//  Saga
//
//  Created by Stavan Gandhi on 9/1/22.
//

import SwiftUI

//class ShareSheet{
//    static let share = ShareSheet()
//
//    func ShareImage(_ img: UIImage) {
//        //        let image = img
//        //
//        //        let string = "Hello, world!"
//        //        let url = URL(string: "https://nshipster.com")!
//
//        let activityViewController = UIActivityViewController(activityItems: [img], applicationActivities: nil)
//        UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
//    }
//
//    func ShareFile(_ fileName: URL) {
////        let pdf = Bundle.main.url(forResource: "Q4 Projections", withExtension: "pdf")
//
//        let activityViewController = UIActivityViewController(activityItems: [fileName], applicationActivities: nil)
//        UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
//    }
//
//    func ShareLink(_ url: String){
//        let url = URL(string: url)!
//
//        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
//        UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
//    }
//
//    func ShareText(_ text: String){
//        let activityViewController = UIActivityViewController(activityItems: [text], applicationActivities: nil)
//        UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
//    }
//}

struct ShareSheet: UIViewControllerRepresentable {
    typealias Callback = (_ activityType: UIActivity.ActivityType?, _ completed: Bool, _ returnedItems: [Any]?, _ error: Error?) -> Void
    
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil
    let excludedActivityTypes: [UIActivity.ActivityType]? = nil
    let callback: Callback? = nil
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities)
        controller.excludedActivityTypes = excludedActivityTypes
        controller.completionWithItemsHandler = callback
        return controller
    }
    
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // nothing to do here
    }
}
