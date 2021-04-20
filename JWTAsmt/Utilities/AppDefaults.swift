//
//  AppDefaults.swift
//  JWTAsmt
//
//  Created by Vaibhav on 11/01/21.
//

import Foundation

import UIKit

class AppDefaults: NSObject {

    static let shared: AppDefaults = { AppDefaults() }()
    
    private let defaults:UserDefaults = UserDefaults.standard;
    
//    var userModel:LoginDto?
    
    //MARK: - Manage Other info
    func save(object:Any, key:String){
        defaults.setValue(object, forKeyPath: key);
        defaults.synchronize();
    }
    
    func get(key: String) -> Any? {
        return defaults.object(forKey: key)
    }
    
    func getData(key: String) -> Any? {
        return defaults.object(forKey: key)
    }
    
    func delete(key:String) {
        defaults.removeObject(forKey: key)
        defaults.synchronize();
    }

    
    //MARK: - Manage logged in user info
    
    // MARK:- PREFERANCE
    /*func getUserInfo() -> LoginDto? {
        if let data = get(key: UserDefaultKey.USER_INFO.rawValue) as? Data {
            let decoder = JSONDecoder()
            if let loginInfo = try? decoder.decode(LoginDto.self, from: data) {
                return loginInfo
            }
        }
        return nil
    }
    
    func saveUserData(loginDetail: LoginDto){
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(loginDetail) {
            save(object: encoded, key: UserDefaultKey.USER_INFO.rawValue)
        }
    }
   
    func saveDeviceToken(token: String){
        save(object: token, key: UserDefaultKey.DEVICE_TOKEN.rawValue)
    }
    
    func getDeviceToken() -> String?{
        return get(key: UserDefaultKey.DEVICE_TOKEN.rawValue) as? String
    }
    
    func saveFcmToken(token: String){
        save(object: token, key: UserDefaultKey.FCM_TOKEN.rawValue)
    }
    
    func getFcmToken() -> String?{
        return get(key: UserDefaultKey.FCM_TOKEN.rawValue) as? String
    }*/
    
}
