//
//  ViewController.swift
//  JWTAsmt
//
//  Created by Vaibhav Sharma on 10/04/21.
//

import UIKit
import CryptoKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "JWT Token"
        print((Date() + 300).timeIntervalSince1970)
        
        let obj = JsonWebToken()
        print(obj.getJWT())
        // Do any additional setup after loading the view.
    }

}

