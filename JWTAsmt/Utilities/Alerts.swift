//
//  Alerts.swift
//  ProjectArchitecture
//
//  Created by Vaibhav on 04/01/21.
//

import Foundation
import UIKit

class Alerts {
    
    // MARK:- Show Alert
    static func showMessage(alertMessage: String?, title: String) {
        let alertController = UIAlertController(title: title, message: alertMessage, preferredStyle:.alert)
        
        let alertButton = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
        })
        alertController.addAction(alertButton)
        
        Alerts.getTopViewController()?.present(alertController, animated: true, completion: nil)
    }
    
    static func showAlert(alertMessage: String?, title: String, alertButtons: [String]?, callback: @escaping (String?) -> Void) {
        let alertController = UIAlertController(title: title, message: alertMessage, preferredStyle:.alert)
        
        for item in alertButtons! {
            let alertButton = UIAlertAction(title: item, style: .default, handler: { (action) -> Void in
                callback( item);
            })
            alertController.addAction(alertButton)
        }
        _ = false
        
        Alerts.getTopViewController()?.present(alertController, animated: true, completion: nil)
    }
    
    static func showAlert( alertMessage: String?, alertButtons: [String]?,  alertStyle: UIAlertController.Style?, callback: @escaping ( String?) -> Void) {
        let alertController = UIAlertController(title: kAppName, message: alertMessage, preferredStyle: alertStyle ?? .alert)
        
        for item in alertButtons! {
            let alertButton = UIAlertAction(title: item, style: .default, handler: { (action) -> Void in
                callback( item);
            })
            alertController.addAction(alertButton)
        }
        
        if alertStyle == .actionSheet {
            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelButton)
        }
        Alerts.getTopViewController()?.present(alertController, animated: true, completion: nil)
    }
    
    static func showTextAlert( alertMessage: String?, alertButton: String?,  alertStyle: UIAlertController.Style?, callback: @escaping ( String?) -> Void) {
        let alertController = UIAlertController(title: kAppName, message: alertMessage, preferredStyle: alertStyle ?? .alert)
        alertController.addTextField { (textField) in
            textField.text = ""
        }
        
        let alertButton = UIAlertAction(title: alertButton, style: .default, handler: { (action) -> Void in
            let textField = alertController.textFields![0]
            callback( textField.text!);
        })
        alertController.addAction(alertButton)
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelButton)
        
        Alerts.getTopViewController()?.present(alertController, animated: true, completion: nil)
    }
    
    
    static func getTopViewController() -> UIViewController? {
        if var topController = kAppDelegateObj.window?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        return nil
    }
}
