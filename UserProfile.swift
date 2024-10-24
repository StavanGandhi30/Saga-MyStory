//
//  Database.swift
//  Saga
//
//  Created by Stavan Gandhi on 6/15/22.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

///  Fetch Journals from database
struct UserProfileDataType{
    var UserID: String = ""
    var Email: String = ""
    var Username: String = ""
    var AccountCreationDate: Date = Date()
    var AccountCreationDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: self.AccountCreationDate)
    }
}

class UserProfile: ObservableObject {
    @Published var profile = UserProfileDataType()
    @Published var signedIn = false
    @Published var status: Bool = false
    
    private var Database = Firestore.firestore().collection("users").document("users")
    
    private let DatabaseRef = Firestore.firestore()
    private let AuthenticationRef = Auth.auth()
    private let storageRef = Storage.storage()
    
    var isSignedIn: Bool { return AuthenticationRef.currentUser != nil }
    
    init(){
        if (AuthenticationRef.currentUser != nil) {
            self.reload()
        }
    }
    
    func reload(){
        self.profile.UserID = self.getUserID()
        self.profile.Email = self.getUserEmail()
        self.signedIn = self.isSignedIn
        
        self.Database = DatabaseRef.collection("users").document(self.profile.UserID)
        self.getProfile()
        self.reloadUser()
    }
    
    func RestoreDefault(){
        self.signedIn = self.isSignedIn
        self.profile = UserProfileDataType()
    }
    
    func reloadUser(completion: ((String?) -> Void)? = nil){
        Auth.auth().currentUser?.reload(completion: { (error) in
            guard let err = error?.localizedDescription else{
                completion?(nil)
                return
            }
            completion?(err)
        })
    }
}

//Log In and Create Account
extension UserProfile{
    // Create User Profile to Database and Firebase Auth
    func createUser(_ email: String, _ pwd: String, completion: ((String?) -> Void)? = nil){
        self.AuthenticationRef.createUser(withEmail: email, password: pwd) { (result, error) in
            guard result != nil, error == nil else {
                completion?(error?.localizedDescription)
                return
            }
            
            self.DatabaseRef
                .collection("users")
                .document("\(self.AuthenticationRef.currentUser!.uid)")
                .setData([
                    "SagaID" : "\(self.AuthenticationRef.currentUser!.uid)",
                    "UserName" : "Saga_\(self.AuthenticationRef.currentUser!.uid)",
                    "Email" : email,
                    "Account Created" : Timestamp(date: Date())
                ]) { error in
                    guard let err = error?.localizedDescription else{
                        completion?(nil)
                        return
                    }
                    completion?(err)
                    
                    AppSettingsViewModel().RestoreAppDefault()
                }
        }
        TransactionalMail.send.newUserEmail(email)
    }
    
    func signInUser(_ email: String, _ pwd: String, completion: ((String?) -> Void)? = nil){
        self.AuthenticationRef.signIn(withEmail: email, password: pwd) { (result, error) in
            guard result != nil, error == nil else {
                completion?(error?.localizedDescription)
                return
            }
            completion?(nil)
        }
    }
    
    func signOutUser(completion: ((String?) -> Void)? = nil){
        do {
            try Auth.auth().signOut()
        } catch let error {
            completion?(error.localizedDescription)
        }
        completion?(nil)
    }
    
    func deactivateAccount(_ email: String, _ pwd: String, _ UserID: String, completion: ((String?) -> Void)? = nil){
        if email.isEmpty || pwd.isEmpty {
            completion?("To Continue, You must fill up all required fields")
        } else{
            self.reauthenticate(email, pwd) { error in
                guard error == nil else{
                    completion?(error)
                    return
                }
                print("Successfully ReAuth")

                self.RestoreDefault()
                
                self.removeAllStorageData(UserID: UserID) { error in
                    guard let err = error else{
                        print("Removed User Storage Data.")
                        self.AuthenticationRef.currentUser?.delete { error in
                            guard let err = error?.localizedDescription else{
                                print("Delete User.")
                                completion?(nil)
                                return
                            }
                            print(err)
                            completion?(err)
                        }
                        return
                    }
                    self.AuthenticationRef.currentUser?.delete { error in
                        guard let err = error?.localizedDescription else{
                            print("Delete User.")
                            completion?(nil)
                            return
                        }
                        print(err)
                        completion?(err)
                    }
//                    completion?(err)
                }
                
                self.removeAllDatabaseData(UserID: UserID) { error in
                    guard let err = error else{
                        print("Removed User Database Data.")
                        completion?(nil)
                        return
                    }
                    print(err)
                    completion?(err)
                }
                
            }
        }
    }
    
    func resetPassword(_ email: String, completion: ((String?) -> Void)? = nil){
        self.AuthenticationRef.sendPasswordReset(withEmail: email) { error in
            guard let err = error?.localizedDescription else {
                completion?(nil)
                return
            }
            completion?(err)
        }
    }
}

//Firebase CRUD
extension UserProfile{
    // Get User Profile to Database
    func getProfile(completion: ((String?) -> Void)? = nil) {
        self.Database
            .getDocument { (document, error) in
                if let document = document, document.exists {
                    self.profile.UserID = String.init(describing:(document.data()!["SagaID"] ?? ""))
                    self.profile.Email = String.init(describing:(document.data()!["Email"] ?? ""))
                    self.profile.Username = String.init(describing:(document.data()!["UserName"] ?? ""))
                    self.profile.AccountCreationDate = (document.data()!["Account Created"] as? Timestamp)?.dateValue() ?? Date()
                    completion?(nil)
                }
                guard let err = error?.localizedDescription else{
                    completion?(nil)
                    return
                }
                completion?(err)
            }
    }
    
    // Adding User Profile to Database
    func addProfile(_ docData: [String: Any], completion: ((String?) -> Void)? = nil) {
        self.Database.setData(docData) { error in
            guard let err = error?.localizedDescription else{
                completion?(nil)
                return
            }
            completion?(err)
        }
    }
    
    // Update Email In Firestore Database
    func updateEmail(_ email: String, _ pwd: String, completion: ((String?) -> Void)? = nil) {
        // ReAuth the User
        self.reauthenticate(self.profile.Email, pwd) { error in
            guard let err = error else{
                // Update the User Email in Firestore Authentication
                self.AuthenticationRef.currentUser?.updateEmail(to: email) { error in
                    guard let err2 = error?.localizedDescription else {
                        // Update the User Email in Firestore Database
                        self.Database.updateData([ "Email": email ]) { error in
                            guard let err = error?.localizedDescription else{
                                completion?(nil)
                                return
                            }
                            completion?(err)
                        }
                        return
                    }
                    completion?(err2)
                }
                return
            }
            completion?(err)
        }
    }
    
    // Update Password In Firestore Database
    func updatePassword(_ oldPwd: String, _ newPwd: String, _ confirmNewPwd: String, completion: ((String?) -> Void)? = nil){
        if oldPwd.isEmpty || newPwd.isEmpty || confirmNewPwd.isEmpty {
            completion?("To Continue, You must fill up all required fields!")
        } else if newPwd != confirmNewPwd {
            completion?("New Password must be same your Confirm New Password!")
        } else if newPwd.count<7 || newPwd.count>20 {
            completion?("New Password must be between 8 to 20 characters long!")
        } else{
            // ReAuth the User
            self.reauthenticate(self.profile.Email, oldPwd) { error in
                guard let err = error else{
                    // Update the User Email in Firestore Authentication
                    self.AuthenticationRef.currentUser?.updatePassword(to: newPwd) { error in
                        guard let err2 = error?.localizedDescription else {
                            completion?(nil)
                            return
                        }
                        completion?(err2)
                    }
                    return
                }
                completion?(err)
            }
        }
    }
    
    // Update Username In Firestore Database
    func updateUsername(_ newUsername: String, completion: ((String?) -> Void)? = nil) {
        if newUsername.count < 10{
            completion?("Username should be more than 10 characters long!")
        } else{
            self.isNewUsernameExist(newUsername) { error in
                guard error == nil else {
                    completion?(error)
                    return
                }
                
                self.Database.updateData([ "UserName": newUsername ]) { error in
                    guard let err = error?.localizedDescription else{
                        completion?(nil)
                        return
                    }
                    completion?(err)
                }
            }
        }
    }
}


// Private Function: getUserID(), getUserEmail()
extension UserProfile{
    private func reauthenticate(_ email: String, _ pwd: String, completion: ((String?) -> Void)? = nil){
        let credential = EmailAuthProvider.credential(withEmail: email, password: pwd)
        
        self.AuthenticationRef.currentUser?.reauthenticate(with: credential) { result, error in
            guard result != nil, error == nil else {
                completion?(error?.localizedDescription)
                return
            }
            
            completion?(nil)
        }
    }
    
    private func getUserID() -> String{
        guard let UserId = self.AuthenticationRef.currentUser?.uid else {
            return "Error"
        }
        return UserId
    }
    
    private func getUserEmail() -> String{
        guard let Email = self.AuthenticationRef.currentUser?.email else {
            return "Error"
        }
        return Email
    }
    
    private func isNewUsernameExist(_ newUsername: String, completion: ((String?) -> Void)? = nil){
        DatabaseRef.collection("users").getDocuments() { (querySnapshot, err) in
            guard let err = err?.localizedDescription else {
                for document in querySnapshot!.documents {
                    if document.data()["UserName"] != nil {
                        if newUsername == document.data()["UserName"] as! String{
                            completion?("Username Already in Use")
                            return
                        }
                    }
                }
                completion?(nil)
                return
            }
            completion?(err)
        }
    }
    
    func removeAllStorageData(UserID: String, completion: ((String?) -> Void)? = nil){
        let storageReference = storageRef.reference().child("users/\(UserID)")
        
        print("\(profile.UserID)")
        
        storageReference.listAll { (result, error) in
            guard let err = error?.localizedDescription else{
                for prefix in result!.prefixes {
                    prefix.listAll { (result, error) in
                        for item in result!.items {
                            item.delete { error2 in
                                guard let err2 = error2 else{
                                    print("File Deleted Successfully")
                                    return
                                }
                                completion?(err2.localizedDescription)
                                print("Error: \(err2.localizedDescription)")
                            }
                        }
                    }
                    completion?(nil)
                }
                
                return
            }
            print(err)
            completion?(err)
        }
    }
    
    private func removeAllDatabaseData(UserID: String, completion: ((String?) -> Void)? = nil){
        let databaseFieldRef = self.DatabaseRef.collection("users").document("\(UserID)")
        let databaseRef = databaseFieldRef.collection("Journal")
        
        databaseFieldRef.delete { error in
            guard let err = error?.localizedDescription else{
                databaseRef.getDocuments { querySnapshot, error in
                    guard let err = error?.localizedDescription else{
                        for document in querySnapshot!.documents {
                            document.reference.delete { error in
                                guard let err = error?.localizedDescription else{
                                    completion?(nil)
                                    return
                                }
                                completion?(err)
                            }
                            print("\(document.reference)")
                        }
                        return
                    }
                    completion?(err)
                }
                return
            }
            completion?(err)
        }
    }
}
