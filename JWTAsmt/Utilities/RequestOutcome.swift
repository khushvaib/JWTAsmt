//
//  RequestOutcome.swift
//  SetupProject
//
//  Created by Vaibhav on 23/11/20.
//

import UIKit

public class RequestOutcome: Codable {
    
    public var success            :Bool?
    public var data               :AnyDecodable?
    public var message            :String?
    public var title              :String?
    
    init() {
        //code
    }
    
    public func isSuccess() -> Bool {
        if success == true {
            return true;
        }
        return false;
    }
    
    enum CodingKeys: String, CodingKey {
        case success
        case data
        case message
        case code
        case title
        //case errors
    }
    
    public func encode(to encoder: Encoder) throws {
        
    }
    
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        data = try values.decodeIfPresent(AnyDecodable.self, forKey: .data)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        title = try values.decodeIfPresent(String.self, forKey: .title)
    }
    
    init(flag:Bool, strMessage:String) {
        self.success = flag
        self.message = strMessage
    }
    
}



