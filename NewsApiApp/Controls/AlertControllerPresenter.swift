//
//  AlertControllerPresenter.swift
//  NewsApiApp
//
//  Created by Димас on 01.04.2021.
//

import Foundation
import UIKit

class AlertControllerPresenter {
    
    static func presentAlertController(_ sender: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        sender.present(alert, animated: true, completion: nil)
    }
    
}
