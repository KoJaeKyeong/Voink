//
//  LoginViewController.swift
//  Voink
//
//  Created by Jae Kyeong Ko on 2022/05/29.
//

import UIKit
import SnapKit
import FBSDKLoginKit
import FBSDKCoreKit
import FirebaseAuth

final class LoginViewController: UIViewController {
    
    lazy var facebookLoginButton = FBLoginButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let token = AccessToken.current, !token.isExpired {
            facebookLoginButton.isHidden = true
            let tabBarController = TabBarController()
            tabBarController.modalPresentationStyle = .overFullScreen
            present(tabBarController, animated: true, completion: nil)
        }
    }
    
    private func configure() {
        configureAttribute()
        configureLayout()
    }
    
    private func configureAttribute() {
        facebookLoginButton.delegate = self
        facebookLoginButton.permissions = ["public_profile", "email"]
    }
    
    private func configureLayout() {
        [facebookLoginButton].forEach { view.addSubview($0) }
        
        facebookLoginButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

extension LoginViewController: LoginButtonDelegate {
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if error == nil {
            loginButton.isHidden = true
            let tabBarController = TabBarController()
            tabBarController.modalPresentationStyle = .overFullScreen
            present(tabBarController, animated: true, completion: nil)
        }
    }

    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("Log Out")
    }
}
