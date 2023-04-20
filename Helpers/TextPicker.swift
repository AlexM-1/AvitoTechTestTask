//
//  TextPicker.swift
//  NavigationApp
//
//  Created by Alex M on 09.02.2023.
//


import UIKit

class TextPicker {
    
    static let `default` = TextPicker()
    
    func showInfo(showIn viewController: UIViewController, title: String, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionCancel = UIAlertAction(title: "OK", style: .cancel)
        alertController.addAction(actionCancel)
        viewController.present(alertController, animated: true)
    }
    
}
