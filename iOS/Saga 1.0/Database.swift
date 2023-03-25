
//---------------------------------------------------------------------------------------------------------------------------------

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import UserNotifications

//---------------------------------------------------------------------------------------------------------------------------------
//   Fetch Data
//


///  Fetch Journals from database
struct JournalDataType: Identifiable{
    var id: String = UUID().uuidString
    
    var title: String
    var entry: String
    var HashTag: [String]
    var Address: String
    var Location: GeoPoint
    var Emoji: [String]?
    var TimeStamp: Timestamp
    var Favorite: Bool
    var documentID: TimeInterval
    var ImageURL: [String]
}

class JournalDataManager: ObservableObject {
    var profile = UserProfile()
    
    @Published var JournalDataVar = [JournalDataType]()
    @Published var countFavoriteJournal: Int?
    @Published var countAllJournal: Int?
    
    init(){
        self.reload()
    }
    
    func reload(){
        self.profile.reload()
        self.FetchData()
        self.countAllJournalFunc()
        self.countFavoriteJournalFunc()
    }
    
    //    Add Data to Firebase Storage
    func PushData(docData: [String: Any], userImageList: [UIImage], documentID: TimeInterval, completion: @escaping (Bool, Error?) -> Void) {
        PathToFirebaseJournalCollection()
            .document("\(documentID)")
            .setData(docData) { error in
                if error != nil {
                    completion(true, error)
                    print(String(describing: error))
                } else {
                    if userImageList.count == 0 {
                        DispatchQueue.main.async {
                            completion(false, nil)
                        }
                    } else{
                        DispatchQueue.main.async {
                            self.AddImg(userImageList: userImageList, documentID: documentID) { error, msg in
                                completion(error, msg)
                            }
                        }
                    }
                    print("Document successfully written!")
                }
            }
    }
    
    func UpdateData(docData: [String: Any], userImageList: [UIImage], documentID: TimeInterval, completion: @escaping (Bool, Error?) -> Void) {
        PathToFirebaseJournalCollection()
            .document("\(documentID)")
            .updateData(docData) { error in
                print("documentID: \(documentID)")
                if error != nil {
                    print(String(describing: error))
                    completion(true, error)
                } else {
                    if userImageList.count == 0 {
                        DispatchQueue.main.async {
                            completion(false, nil)
                        }
                    } else{
                        DispatchQueue.main.async {
                            self.AddImg(userImageList: userImageList, documentID: documentID) { error, msg in
                                completion(error, msg)
                            }
                        }
                    }
                    print("Document successfully written!")
                }
            }
    }
        
    func AddImg(userImageList: [UIImage], documentID: TimeInterval, completion: @escaping (Bool, Error?) -> Void) {
        var uploadedInt = 0
        
        for (index,image) in userImageList.enumerated(){
            let storagePath = "users/\(profile.profile.UserID)/\(documentID)/\(index).jpg"
            let storageRef = Storage.storage().reference(withPath: storagePath)
            
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
        
            
            let imgData = NSData(data: image.jpegData(compressionQuality: 1)!)
            let imageSize: Double = Double(imgData.count) / 10000.0
            
            
            var imageData: Data{
                if imageSize > 200.0{
                    print("\(imageSize) is more than 200.")
                    return image.jpegData(compressionQuality: 0.4)!
                } else{
                    print("\(imageSize) is less than 200.")
                    return image.jpegData(compressionQuality: 0.8)!
                }
            }
            
            storageRef.putData(imageData, metadata: metadata) { metadata, err in
                if let err = err {
                    print("Error: \(err)")
                }

                storageRef.downloadURL { url, err in
                    DispatchQueue.main.async {
                        if let err = err {
                            print("Error: \(err)")
                            completion(true,err)
                        } else{
                            print("Data succesfully added to Storage database with URL: \(url?.absoluteString ?? "")")
                            print("index: \(uploadedInt) ; userImageList.count: \(userImageList.count)")
                            if uploadedInt == userImageList.count-1 {
                                completion(false,nil)
                            }
                            uploadedInt = uploadedInt + 1
                        }
                    }
                }
            }
        }
    }
        

//    Fetch Data to Firebase Storage
    func FetchData() {
        PathToFirebaseJournalCollection()
            .order(by: "TimeStamp", descending: true)
            .addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                self.JournalDataVar = documents.map { queryDocumentSnapshot -> JournalDataType in
                    let data = queryDocumentSnapshot.data()
                    let Title = data["Title"] as? String ?? ""
                    let Entry = data["Entry"] as? String ?? ""
                    let Emoji = data["Emoji"] as? [String] ?? nil
                    let TimeStamp = data["TimeStamp"] as? Timestamp
                    let HashTag = data["HashTag"] as? [String]
                    let Address = data["Address"] as? String ?? ""
                    let Location = data["Location"] as? GeoPoint
                    let Favorite = data["Favorite"] as? Bool
                    let documentID = data["documentID"] as? TimeInterval ?? NSDate().timeIntervalSince1970
                    let ImageURL = data["ImageURL"] as? [String]
                    
                    return JournalDataType(
                        title: Title,
                        entry: Entry,
                        HashTag: HashTag!,
                        Address: Address,
                        Location: Location!,
                        Emoji: Emoji,
                        TimeStamp: TimeStamp!,
                        Favorite: Favorite!,
                        documentID: documentID,
                        ImageURL: ImageURL!
                    )
                }
            }
    }
    
    func FetchImage(ImageURL: [String], completion: @escaping ([String:UIImage], Bool) -> Void){
        var ImageList = [String : UIImage]()
        let storage = Storage.storage().reference()
        
        for url in ImageURL{
            let imageRef = storage.child(url)
            imageRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                if error != nil {
                    print("\(error?.localizedDescription)")
                } else {
                    DispatchQueue.main.async {
                        ImageList[url] = UIImage(data: data!)!
                        
                        if ImageList.count == ImageURL.count {
                            completion(ImageList, true)
                        }
                    }
                }
            }
        }
    }
    
    func countFavoriteJournalFunc(){
        PathToFirebaseJournalCollection()
            .whereField("Favorite", isEqualTo: true)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)");
                } else{
                    self.countFavoriteJournal = querySnapshot!.documents.count
                }
        }
    }
    
    func countAllJournalFunc(){
        PathToFirebaseJournalCollection()
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    self.countAllJournal = querySnapshot!.documents.count
                }
        }
    }
    
    
//    Delete Data to Firebase Storage
    func DeleteData(userID: String, documentID: TimeInterval, completion: @escaping (Bool, Error?) -> Void){
        PathToFirebaseJournalCollection()
        .document("\(documentID)")
        .delete() { error in
            if let error = error {
                completion(true, error)
                print(error)
            } else {
//                completion(false, error)
                print("Document successfully deleted!")
            }
        }
        
        let storageReference = Storage.storage().reference().child("users/\(userID)/\(documentID)")

        storageReference.listAll { (result, error) in
            guard let err = error?.localizedDescription else{
                for item in result!.items {
                    item.delete { error2 in
                        guard let err2 = error2 else{
                            print("File Deleted Successfully")
                            return
                        }
                        print("Error: \(err2.localizedDescription)")
                    }
                }
                return
            }
            print(err)
        }
    }


//    SetUp Variable to Firebase Storage
    func PathToFirebaseJournalCollection() -> CollectionReference{        
        return Firestore.firestore()
            .collection("users")
            .document(profile.profile.UserID == "" ? "users" : profile.profile.UserID)
            .collection("Journal")
    }
}

func FirebaseTimeStampToString(TimeStamp: Timestamp, to: String = "yyyy-MM-d") -> String{
    let formatter = DateFormatter()
    formatter.dateFormat = to
    return formatter.string(from: TimeStamp.dateValue())
}

func FirebaseImageURL(url: String) -> URL{
    let urlString  = "https://firebasestorage.googleapis.com/v0/b/saga-mystory.appspot.com/o/" + url.replace(string: "/", replacement: "%2F") + "?alt=media"
    return URL(string: urlString)!
}
