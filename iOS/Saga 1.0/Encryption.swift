//
//  Encryption.swift
//  Saga
//
//  Created by Stavan Gandhi on 8/16/22.
//

//import Foundation
import SwiftUI
import RNCryptor


class Security{
    static let instance = Security()
}

extension Security{
    func encrypt(text: String, _ encryptionKey: String) throws -> String {
        let textData = text.data(using: .utf8)!
        let cipherData = RNCryptor.encrypt(data: textData, withPassword: encryptionKey)
        
        return cipherData.base64EncodedString()
    }

    func decrypt(encryptedText: String, _ encryptionKey: String) throws -> String {
        let encryptedTextData = Data.init(base64Encoded: encryptedText)!
        let decryptedData = try RNCryptor.decrypt(data: encryptedTextData, withPassword: encryptionKey)
        let decryptedString = String(data: decryptedData, encoding: .utf8)!

        return decryptedString
    }
}
