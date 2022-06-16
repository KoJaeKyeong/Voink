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
import FirebaseFunctions

final class LoginViewController: UIViewController {
    
    private lazy var functions = Functions.functions()
    
    private lazy var facebookLoginButton = FBLoginButton()
    private let viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getHandshake()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let token = AccessToken.current, !token.isExpired {
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
        if let token = AccessToken.current, !token.isExpired {
            facebookLoginButton.isHidden = true
        }
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

extension LoginViewController: ServerCommunication {
    func getHandshake() {
        guard let url = URL(string: "handshake", relativeTo: URL(string: KeyStorage().serverURL)) else { return }
        let session = URLSession(configuration: .default)
        var request = URLRequest(url: url)
        request.timeoutInterval = 10
        
        let dataTask = session.dataTask(with: request) { [weak self] data, response, error in
            guard error == nil,
                  let response = response as? HTTPURLResponse,
                  let self = self else {
                DispatchQueue.main.async {
                    self?.viewModel.showAlert(title: "Sorry, can't execute Voink", message: "Cannot connect to server", viewController: self ?? UIViewController())
                }
                return
            }
            
            if response.statusCode == 200 {
                DispatchQueue.main.async {
                    self.configure()
                }
            } else {
                DispatchQueue.main.async {
                    self.viewModel.showAlert(title: "Sorry, can't execute Voink", message: "Cannot connect to server", viewController: self)
                }
            }
        }
        
        dataTask.resume()
    }
    
    func postLoginToken() {
        let url = URL(string: "handshake", relativeTo: URL(string: KeyStorage().serverURL))
        
        let session = URLSession(configuration: .default)
//        let dataTask = session.dataTask(with: url) { [weak self] data, response, error in
//            guard error == nil,
//                  let response = response as? HTTPURLResponse,
//                  200..<300 ~= response.statusCode else { return }
//        }
//
//        dataTask.resume()
    }
}
