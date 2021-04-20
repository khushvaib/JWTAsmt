//
//  Services.swift
//  Yogous
//
//  Created by IOS on 03/03/20.
//  Copyright © 2020 IOS. All rights reserved.
//

import Foundation
import UIKit
import Alamofire


// MARK:- Service Configuration

private struct ServiceConfig {
//    static let development = "http://192.168.0.250:"
//    static let development = "http://mymeetingdesk.com:"
    
    static let development = "http://mymeetingdesk.com:"
    
    //http://mymeetingdesk.com:6162/
    static let staging = "http://mymeetingdesk.com:"
    static let production = "http://mymeetingdesk.com:"
    
}

//http://mymeetingdesk.com:6163
private struct ServiceConfigSocket {
    static let development = "http://mymeetingdesk.com:"
    static let staging = "http://mymeetingdesk.com:"
    static let production = "http://mymeetingdesk.com:"
    
}

//
//200    Success    Whenever API request completes without any error
//201    Success    Whenever API request creates a record without any error
//400    Bad request error    Whenever API got any kind of erro due to client req, eg- validation errors
//500    Server error    Whenver ther are internal server errors, databae errors, syntax errors and crashs.
//440    Required Login    When we need user to forcefully logout and re login again.
//308    Force Update    When we want user to update its application to latest version.
enum ApiResponseErrorCodes: String {
    case SUCCESS_CODE = "200"
    case NON_VERIFIED_CODE = "203"
    case BAD_REQUEST_CODE = "400"
    case UNAUTHORIZED_CODE = "401"
    case FORBIDDEN = "403"
    case NOT_FOUND_CODE = "404"
    case NON_REGISTERED_USER = "405"
    case FORCE_UPDATE_CODE = "406"
    case CONFLICT_CODE = "409" // for error type
    case FORCE_LOGOUT_CODE = "440"
}

enum ServiceEnvironment: String {
    case development = "development"
    case staging = "staging"
    case production = "production"
}

//change in staging Socket evrytime
var host = ""
var hostSocket = ""
var currentEnvironment: String!

// MARK:- APIs
enum ServiceAPI {
    
    case apiLogin
    case apiRegister
    case apiSocialLogin
    case apiSocialRegister
    case apiUinqueVerify(uniqueString:String)
    case apiEmailUniqueVerify(uniqueString:String)
    case apiTagUniqueVerify(uniqueString:String)
    case apiForgotPassword
    case apiResetPwd
    case apiChangePassword
    
    //*******
    case OTP_Verification
    case OTP_Re_Send
    case AppleLogin
    case AppleRegister
    case LanguageList
    case TopicList
    case ResetTopics
    case UpdateTopics
    case UpdateLanguage
    case UserProfile
    case UpdateNotificaionStatus
    case UserProfileCompleted
    case UpdateNotificaioStatus
    case GetCMSContent
    case GetSelectedTopicsCounts
    case UserUpdateProfile
    case UserChangePassword
    case SearchSubTopics
    case MainTopicsList
    case SuggestTopic
    case GenerateTwilioToken
    case AddTopicAsFavorite
    case FavoriteTopicList
    case LOGOUT_USER
    case CheckCallIsStarted
    case ReviewCall
    case CallAnswer
    case SearchTopicsAndSubTopics
    case DisconnectCall
//    case SuggestATopic
    
    // destination apis
    case MapInformation
    case UpdateLocation
    case FavDestinationList // /topics/favorite-destination-list
    case MarkDestAsFav // ​/topics​/favorite-destination
    case RemoveFavDestination
    case CallHistory
    //******
    
   //// *** Socket Api ***
    ///
    //// *** Socket Api ***
    case loginSocket
    
    enum ServicePort: String {
        case authentication
        case profile
        case connectSocket
        
        func authPort() -> String {
            // port 6062 for client and 6162 for internal testing
            currentEnvironment == "development" ? "6162" : currentEnvironment == "staging" ? "6062" : ""
//            client server
//            currentEnvironment == "development" ? "6062" : currentEnvironment == "staging" ? "15502" : ""
            
        }
        func profilePort() -> String { currentEnvironment == "development" ? "15504" : currentEnvironment == "staging" ? "15504" : ""
        }
        
        func socketPort() -> String {
            currentEnvironment == "development" ? "6163" : currentEnvironment == "staging" ? "6063" : ""
        }
        
    }
    
    
    func urlString() -> String {
        
        let prefixAuth = (host+ServicePort.authentication.authPort())
        let prefixProfile = (host+ServicePort.profile.profilePort())
        let prefixSocket = (host+ServicePort.connectSocket.socketPort())
        
        
        switch self {
        case .apiLogin:
            return prefixAuth+"/auth/login"
        case .apiRegister:
            return prefixAuth+"/auth/signup"
        case .apiSocialLogin:
            return prefixAuth + "/social-login"
        case .apiSocialRegister:
            return prefixAuth + "/social-register"
        case .apiForgotPassword:
            return prefixAuth + "/auth/forgot-password"
        case .apiUinqueVerify(let str):
            return prefixAuth + "/is_unique?username="+str
        case .apiEmailUniqueVerify(let str):
            return prefixAuth + "/is_unique?email="+str
        case .apiTagUniqueVerify( let str):
            return prefixAuth + "/is_unique?apiToken="+str
            
            //****************
        case .OTP_Verification:
            return prefixAuth + "/auth/verify-otp"
            
        case .OTP_Re_Send:
            return prefixAuth + "/auth/resend-otp"
            
        case .AppleLogin:
            return prefixAuth + "/auth/social-login"
            
        case .AppleRegister:
            return prefixAuth + "/auth/social-signup"
            
        case .LanguageList:
            return prefixAuth + "/auth/language-list"
            
        case .TopicList:
            return prefixAuth + "/topics/topic-list"
            
        case .ResetTopics:
            return prefixAuth + "/topics/reset-topic-list"
            
        case .UpdateTopics:
            return prefixAuth + "/topics/add-topic"
            
        case .UpdateLanguage:
            return prefixAuth + "/users/update-profile-language"
            
        case .UserProfile:
            return prefixAuth + "/users/profile"
            
        case .UpdateNotificaionStatus:
            return prefixAuth + "/auth/update-notification"
            
        case .UserProfileCompleted:
            return prefixAuth + "/users/profile-complete"
            
        case .UpdateNotificaioStatus:
            return prefixAuth + "/auth/update-notification"
            
        case .GetCMSContent:
            return prefixAuth + "/users/get-page?pageSlug=term-conditions"
            
        case .GetSelectedTopicsCounts:
            return prefixAuth + "/topics/check-valid-sub-topic-select"
            
        case .UserUpdateProfile:
            return prefixAuth + "/users/update-profile"
            
        case .UserChangePassword:
            return prefixAuth + "/users/change-password"
            
        case .MainTopicsList:
            return prefixAuth + "/topics/main-topic-list"
            
        case .SearchSubTopics:
            return prefixAuth + "/topics/search-sub-topic"
            
        case .SuggestTopic:
            return prefixAuth + "/topics/suggest-topic"
            
        case .GenerateTwilioToken:
            return prefixAuth + "/calls/get-video-call-token"
            
        case .AddTopicAsFavorite:
            return prefixAuth + "/topics/favorite-topic"
            
        case .FavoriteTopicList:
            return prefixAuth + "/topics/favorite-topic-list"
            
        case .LOGOUT_USER:
            return prefixAuth + "/auth/log-out"
            
        case .CheckCallIsStarted:
            return prefixAuth + "/calls/check-is-call-start"
            
        case .ReviewCall:
            return prefixAuth + "/calls/review-call"
            
        case .CallAnswer:
            return prefixAuth + "/calls/answer-call"
            
        case .SearchTopicsAndSubTopics:
            return prefixAuth + "/topics/search-sub-topic"
            
        case .DisconnectCall:
            return prefixAuth + "/calls/cancle-video-call"
            //****************
            
        case .apiChangePassword:
            return prefixProfile + "/change-password"
        case .apiResetPwd:
            return prefixAuth + "/auth/reset-password"
            
        case .MapInformation:
            return prefixAuth + "/users/get-admin-setting"
            
        case .UpdateLocation:
            return prefixAuth + "/users/update-destination"
            
        case .FavDestinationList:
            return prefixAuth + "/topics/favorite-destination-list"
       
        case .MarkDestAsFav:
            return prefixAuth + "/topics/favorite-destination"
            
        case .RemoveFavDestination:
            return prefixAuth + "/topics/favorite-destination-remove"
            
        case .CallHistory:
            return prefixAuth + "/calls/call-history"

            //***SOCKET
        case .loginSocket:
            return prefixSocket + "login"
            
        
        }
    }
}

//MARK:- Services

class Services {
    
    //Initalize Environment
    static func initWebServicesEnvironment(_ environment: ServiceEnvironment) {
        var environment: ServiceEnvironment = environment
        
        // commented for demo purpose
        /*if let serviceEnv = Bundle.main.infoDictionary?["ServicesEnvironment"] as? String,
            let env = ServiceEnvironment(rawValue: serviceEnv) {
            environment = env
        }*/
        
//        environment = ServiceEnvironment.development //
        
        switch environment as ServiceEnvironment {
        case .development:
            host = ServiceConfig.development
            currentEnvironment = "development"
            hostSocket = ServiceConfigSocket.development
            break
        case .staging:
            host = ServiceConfig.staging
            currentEnvironment = "staging"
            hostSocket = ServiceConfigSocket.staging
            break
        case .production:
            host = ServiceConfig.production
            hostSocket = ServiceConfig.production
            currentEnvironment = "production"
            break
        }
    }
    
    typealias CompletionHandler = (_ response:AFDataResponse<Any>?, _ error:AFError?, _ httpResponseCode: Int) -> ()
    
    typealias CompletionHandlerNew = (_ responseObj: RequestOutcome,_ responseCode: Int) -> ()
    typealias CompletionHandlerGet = (_ response:AFDataResponse<Any>?, _ error:AFError?) -> ()
    typealias GetApiCompletionHandlerResponse = (_ responseDict:AFDataResponse<Any>?,_ error: Error?, _ httpResponseCode: Int) -> ()
    typealias PostApiCompletionHandlerResponse = (_ responseDict:Dictionary<String,Any>?,_ error: Error?, _ httpResponseCode: Int) -> ()
    
    static func getApiHeaders() -> HTTPHeaders {
        
        let headers: HTTPHeaders = [
            "X-harmony-Version"     :   "1.0.0",
            "Accept-Language"       :   "en",
            "X-harmony-Platform"    :   "ios"
        ]
        
        let token =  UserDefaults.standard.value(forKey: kDeviceToken) as? String ?? ""
        Helper.deviceToken = token
        return headers
    }
}


// MARK:- Services
extension Services {
    
    class func makeRequest(isShowHud:Bool,urlString:String, method: HTTPMethod, parameters: [String:Any]?, completionHandler: @escaping (RequestOutcome) -> Void/*CompletionHandler?*/) {
        
        // added code
        guard Reachability.isConnectedToNetwork() else {
            Alerts.showMessage(alertMessage: "Messages.noInternetConn.rawValue", title: "Asmt")
            return
        }
        
        // showing loader
//        if isShowHud {  ProgressActivity.showProgress() }
        
        print("urlString", urlString)
        ///////////////////////////////////////////////////////////////
        print("Headers: ", getApiHeaders())
        print("\n==== Body params: ===\n \(parameters ?? [:])")
        
        AF.request(urlString, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: getApiHeaders())
            .validate(statusCode: 200..<600).responseJSON {(response:AFDataResponse<Any> ) in
                
                print("response", response)
                
                // hiding loader
//                if isShowHud {  ProgressActivity.dismissProgress()  }
                
                //Force Update
                if false {
                    if response.response?.allHeaderFields["update_available"] as? String == "1" {
                        print(response.response?.allHeaderFields ?? "")
                        if response.response?.allHeaderFields["force_update"] as? String == "1" {
                            //showUpdateAlert()
                            return
                        }
                        else {
                            //Soft Update
                            let dictionary = Bundle.main.infoDictionary!
                            let version = dictionary["CFBundleShortVersionString"] as! String
                            if ((response.response?.allHeaderFields["App-version"] as? String ?? "") > version ) {
                                
                                // show alert
                            }   else {
                                
                                // show alert
                            }
                        }
                    }
                }
                
                //Check Status code
                guard let statusCode = response.response?.statusCode else {
                    completionHandler(self.getErrorMessage())
                    return
                }
                
                self.requestCallBack(response: response, statusCode: statusCode) { (response) in
                    completionHandler(response) }
                
        }
    }
    
    
    static func getErrorMessage(_ message:String = "Something went wrong") -> RequestOutcome {
        return RequestOutcome(flag: false, strMessage: message)
    }
    
    //*********** added method
    static func requestCallBack(response: AFDataResponse<Any>, statusCode: Int, callback: (RequestOutcome) -> Void)  {
        
        switch response.result {
        case .success(_):
            if statusCode == 200 || statusCode == 404{
                if let value = response.value as? [String: Any]{
                    let decoder = JSONDecoder()
                    do {
                        let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let object = try! decoder.decode(RequestOutcome.self, from: data)
                        callback(object)
                    } catch {
                        callback(RequestOutcome(flag: false, strMessage: response.error.debugDescription))
                    }
                }else{
                    callback(RequestOutcome(flag: false, strMessage: "No Server Response"))
                }
                
//                let dict = response.value as? [String: Any]
//                self.handleForceUpdate(message: dict?["message"] as! String)
            }
            else{
                let dict = response.value as? [String: Any]
                Alerts.showMessage(alertMessage: (dict?["message"] as! String), title: "Harmony")
            }
            //
        case .failure(_):
            callback(RequestOutcome(flag: false, strMessage: "No Server Response"))
        }
    
    }
    
    //***********
    //Force Update Alert
    
    class func showUpdateAlert() {
        /*Helper.showDoubleBoxAlertOverAnyVC(message: kForceUpdateMessage, flag: true) { (status) in
            if status {
                UIApplication.shared.open(NSURL(string:kAppLink)! as URL, options: [:], completionHandler: nil)
            }
        }*/
    }
    
    //MARK:-Get API
    
    class func makeGetRequest(isShowHud:Bool,urlString:String,completionHandler: @escaping (RequestOutcome) -> Void/*@escaping CompletionHandlerGet*/) {
        
        guard Reachability.isConnectedToNetwork() else {
            Alerts.showMessage(alertMessage: kInternetNotConnected, title: "Harmony")
            return
        }
        
//        if isShowHud {  ProgressActivity.showProgress() }
        
        let urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        print("urlString", urlString)
        ///////////////////////////////////////////////////////////////
        print("headers", getApiHeaders())
        
        AF.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: getApiHeaders())
            .responseJSON {(response:AFDataResponse<Any>) in
                
//                ProgressActivity.dismissProgress()
                
                print(response)
                
                guard let statusCode = response.response?.statusCode else {
                    completionHandler(self.getErrorMessage())
                    return
                }
                
                requestCallBack(response: response, statusCode: statusCode) { (response) in
                    completionHandler(response)
                }
        }
    }
    
    //Image Upload code
    //Upload Image
    class func uploadImageVideo(data: Data, urlString: String, mimeType: String,completion: @escaping (Bool?, String?) -> Void) {
        
        //Helper.showLoadingSpinner()
        let requestURL = URL(string: urlString)!
        
        print(urlString)
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        request.httpBody = data
        request.setValue(mimeType, forHTTPHeaderField: "Content-Type")
        request.setValue("\(data.count)", forHTTPHeaderField: "Content-Length")
        request.setValue("public-read", forHTTPHeaderField: "x-amz-acl")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                completion(false, error.localizedDescription)
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                return
            }
            
            if httpResponse.statusCode == 200 {
                completion(true,nil)
            }
                
            else {
                completion(false,nil)
            }
        }
        task.resume()
    }
    
}

    
    
