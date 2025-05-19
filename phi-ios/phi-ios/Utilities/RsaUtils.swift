//
//  RsaUtils.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/5/6.
//

import Foundation
import KeychainSwift
import Security

class RsaUtils {
    // Function to encrypt data using RSA public key with PKCS1 padding
    class func encryptData(data: Data, publicKey: SecKey) throws -> Data {
        var error: Unmanaged<CFError>?
        guard let encryptedData = SecKeyCreateEncryptedData(publicKey, .rsaEncryptionPKCS1, data as CFData, &error) else {
            throw error!.takeRetainedValue() as Error
        }
        return encryptedData as Data
    }

    class func generateEncryptedData(src: String) -> String {
        let plainTextData = src.data(using: .utf8)!
        var publicKeyString: String = ""
        var rt: String = ""
        
        let keychain = KeychainSwift()
        if (keychain.get("RSAKey") ?? "").isEmpty {
            publicKeyString = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDUWsXqQz13pJAri2nYcpp0L7izUrW4pPwyhnQs4I7BAhkDy8kDOiYAHyWaABULOqS/TVwdkiIUOdwOQQky3lbvSNwKyx4GC2QnfGaiMfXDj42xv/q5M7aMvxtUICWJ3cZog0NUbNvcbiG4ZgngRF/x1NBUtLgnjDfMpuBoB8eNQQIDAQAB"
        } else {
            publicKeyString = keychain.get("RSAKey") ?? ""
        }
        
        let publicKeyData = Data(base64Encoded: publicKeyString)!
        let attributes: [NSObject: Any] = [
            kSecAttrKeyType: kSecAttrKeyTypeRSA,
            kSecAttrKeyClass: kSecAttrKeyClassPublic,
            kSecAttrKeySizeInBits: NSNumber(value: 1024)
        ]

        var error: Unmanaged<CFError>?
        guard let publicKey = SecKeyCreateWithData(publicKeyData as CFData, attributes as CFDictionary, &error) else {
            fatalError("Error creating public key: \(error!.takeRetainedValue() as Error)")
        }

        do {
            let encryptedData = try encryptData(data: plainTextData, publicKey: publicKey)
            let encryptedBase64String = encryptedData.base64EncodedString()
            //print("Encrypted data: \(encryptedBase64String)")
            
            rt = encryptedBase64String
        } catch {
            print("Encryption failed with error: \(error)")
        }
        
        return rt
    }
}
