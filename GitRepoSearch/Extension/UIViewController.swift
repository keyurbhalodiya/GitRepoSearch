//
//  UIViewController.swift
//  GitRepoSearch
//
//  Created by Bhalodiya, Keyur Ratilal | Kb | ECMPD on 2022/10/25.
//

import UIKit

extension UIViewController {
    
    /// to preset alert with `OK` button
    func showAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) -> Void in
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
