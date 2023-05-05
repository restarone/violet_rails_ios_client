//
//  Alerts.swift
//  Violet Rails
//
//  Created by Joses Solmaximo on 05/05/23.
//

import UIKit

struct Alerts {
    static func okAlert(title: String?, message: String?) -> UIAlertController {
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(okAction)
        
        return alert
    }
}
