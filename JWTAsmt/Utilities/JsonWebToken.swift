//
//  JsonWebToken.swift
//  JWTAsmt
//
//  Created by Vaibhav Sharma on 10/04/21.
//

import CryptoKit
import UIKit

class JsonWebToken {
    
    func getJWT() -> String{
        return self.generateJwtToken()
    }
    
    private func generateJwtToken() -> String{
        
        let secret = "58627c2e-d2f7-47ec-8ab6-b193a1f88658"
        let privateKey = SymmetricKey(data: secret.data(using: .utf8)!)

        let headerJSONData = try! JSONEncoder().encode(Header())
        let headerBase64String = headerJSONData.urlSafeBase64EncodedString()

        let payloadJSONData = try! JSONEncoder().encode(Payload())
        let payloadBase64String = payloadJSONData.urlSafeBase64EncodedString()

        let toSign = (headerBase64String + "." + payloadBase64String).data(using: .utf8)!

        let signature = HMAC<SHA256>.authenticationCode(for: toSign, using: privateKey)
        
        let signatureBase64String = Data(signature).urlSafeBase64EncodedString()

        let token = [headerBase64String, payloadBase64String, signatureBase64String].joined(separator: ".")
        return token
    }
}

extension Data {
    func urlSafeBase64EncodedString() -> String {
        return base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }
}

struct Header: Encodable {
    let alg = "HS256"
    let typ = "JWT"
}

struct Payload: Encodable {
    
    /**
     {
     "clientId": "ebc38746-4bbe-4fd9-b695-3bd44ecb3afc", "individualId": "591cbcdf-4fec-4206-b651-2b7bf645979e",
     "canAssess": [ "591cbcdf-4fec-4206-b651-2b7bf645979e"
     ], "canMonitor": [
     "591cbcdf-4fec-4206-b651-2b7bf645979e" ],
     "role": "consumer",
     "exp": "1497281798"
     }
     */
    let clientId = "ebc38746-4bbe-4fd9-b695-3bd44ecb3afc"
    let individualId = "591cbcdf-4fec-4206-b651-2b7bf645979e"
    let canAssess = ["591cbcdf-4fec-4206-b651-2b7bf645979e"]
    let canMonitor = ["591cbcdf-4fec-4206-b651-2b7bf645979e"]
    let role = "consumer"
    let exp = (Date() + 300 /*in seconds*/).timeIntervalSince1970
}




