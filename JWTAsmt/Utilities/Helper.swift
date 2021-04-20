//
//  Helper.swift
//  ProjectArchitecture
//
//  Created by Vaibhav on 31/12/20.
//

import Foundation
import UIKit

class Helper: NSObject {
    
    static var deviceToken : String = ""
    static var AuthToken : String = ""
//    static var userInfo : LoginDto!
    
    
    static func modelIdentifier() -> String {
        if let simulatorModelIdentifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] { return simulatorModelIdentifier }
        var sysinfo = utsname()
        uname(&sysinfo) // ignore return value
        return String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
    }
    
    static func jsonToData(json: Any) -> Data? {
        do {
            return try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil
    }
    
   /* static func saveUserData (_ userData: LoginDto) {
        UserDefaults.standard.removeObject(forKey: kUserDefualtUserInfoKey)
//        UserDefaults.standard.setStruct(userData, forKey: kUserDefualtUserInfoKey)
        // UserDefaults.standard.synchronize()
    }*/
    
    
    static func emailValidation(_ email: String)-> Bool{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
}

public extension Dictionary {
    func toJson() -> String {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
            return String(data: jsonData, encoding: String.Encoding.ascii)!
            
        } catch {
            return error.localizedDescription
        }
    }
    
}
