//
//  UIViewController+Extensions.swift
//  rta-assigment5
//
//  Created by Truong Luan on 2/22/23.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        //Add a UIAlertAction with OK label
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        //Present the alert
        self.present(alert, animated: true, completion: nil)
    }
}
