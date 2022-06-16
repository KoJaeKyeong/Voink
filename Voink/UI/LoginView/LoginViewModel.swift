//
//  LoginViewModel.swift
//  Voink
//
//  Created by Jae Kyeong Ko on 2022/06/09.
//

import UIKit

struct LoginViewModel {
    func showAlert(title: String?, message: String?, viewController: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        
        alertController.addAction(action)
        viewController.present(alertController, animated: false, completion: nil)
    }
}
