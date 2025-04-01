//
//  UIViewController+PresentAlert.swift
//  HabitMinder 21 Days
//
//  Created by Mahyar on 1/2/25.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { alert.addAction($0) }
        present(alert, animated: true, completion: nil)
    }
    
    func createAlertAction(title: String, style: UIAlertAction.Style, handler: ((UIAlertAction) -> Void)?) -> UIAlertAction {
        UIAlertAction(title: title, style: style, handler: handler)
    }
}
