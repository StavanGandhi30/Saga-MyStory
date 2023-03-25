//
//  Styling.swift
//  Saga
//
//  Created by Stavan Gandhi on 6/16/22.
//

import SwiftUI


struct ManageLoginTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(.subheadline)
            .autocapitalization(.none)
            .disableAutocorrection(false)
    }
}

struct ManageLoginButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(.subheadline, design: .rounded))
            .padding()
            .padding(.horizontal)
            .background(Color.ThemeAlter)
            .foregroundColor(Color.Default)
            .cornerRadius(25)
    }
}

struct TextView: UIViewRepresentable {
    @Binding var attributedText: NSMutableAttributedString
    @State var allowsEditingTextAttributes: Bool = false
    @State var font: UIFont?

    func makeUIView(context: Context) -> UITextView {
        UITextView()
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.attributedText = attributedText
        uiView.allowsEditingTextAttributes = allowsEditingTextAttributes
        uiView.font = font
    }
}

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}


func alertMessage(_ title: String = "Error", message: String) -> Alert {
    return Alert(
        title: Text(title),
        message: Text(message),
        dismissButton: .default(Text("Got it!"))
    )
}


//struct HashTagChipView: View{
//    @Binding var hashTags: [String]
//    @Binding var onTap: String
//    @State private var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible())]
//    
//    var body: some View{
//        VStack{
//            ScrollView(.horizontal, showsIndicators: false){
//                HStack{
//                    LazyHGrid(rows: gridItemLayout){
//                        Text("All")
//                            .font(.system(.caption, design: .rounded))
//                            .padding(.horizontal)
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 10)
//                                    .stroke(Color("Theme.Text.FG"), lineWidth: 1)
//                                    .background(
//                                        Color("Theme.Button.BG.Alter")
//                                            .opacity(onTap == "" ? 1.0 : 0.0)
//                                    )
//                            )
//                            .padding()
//                            .onTapGesture {
//                                onTap = ""
//                            }
//                        ForEach(hashTags, id: \.self) { hashTag in
//                            Text("#\(hashTag)")
//                                .font(.system(.caption, design: .rounded))
//                                .padding(.horizontal)
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: 10)
//                                        .stroke(Color("Theme.Text.FG"), lineWidth: 1)
//                                        .background(
//                                            Color("Theme.Button.BG.Alter")
//                                                .opacity(onTap == hashTag ? 1.0 : 0.0)
//                                        )
//                                )
//                                .padding()
//                                .onTapGesture {
//                                    onTap = hashTag
//                                }
//                        }
//                    }
//                }
//            }
//        }
//    }
//}

extension Date {
    func getLocalTimeFromGMT(UTCDate: Date) -> Date {
        let timezoneOffset = TimeZone.current.secondsFromGMT()
        let epochDate = UTCDate //sample.startDate
        let timezoneEpochOffset = (epochDate + Double(timezoneOffset))
        
        return timezoneEpochOffset
    }
}


func screenHeight() -> Int{
    return Int(UIScreen.main.bounds.height)
}
func screenWidth() -> Int{
    return Int(UIScreen.main.bounds.width)
}


/*
 
 
{"data":[{"latitude":41.958438,"longitude":-88.158429,"type":"address","name":"2139 Green Bridge Ln","number":"2139","postal_code":"60133","street":"Green Bridge Ln","confidence":1,"region":"Illinois","region_code":"IL","county":"DuPage County","locality":"Hanover Park","administrative_area":"Bloomingdale Township","neighbourhood":null,"country":"United States","country_code":"USA","continent":"North America","label":"2139 Green Bridge Ln, Hanover Park, IL, USA"}]}
 
 */
