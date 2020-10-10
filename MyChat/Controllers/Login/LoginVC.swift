//
//  LoginVC.swift
//  MyChat
//
//  Created by vikas on 07/10/20.
//  Copyright © 2020 vikas. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginVC: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let imageView:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let emailTF:UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.placeholder = "email address ..."
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.returnKeyType = .continue
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        return field
    }()
    
    private let passwordTF:UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.placeholder = "password ..."
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.returnKeyType = .done
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.isSecureTextEntry = true
        return field
    }()
    
    private let loginBtn:UIButton = {
        let button = UIButton()
        button.setTitle("Log In", for: .normal)
        button.titleLabel?.textColor = .black
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1
        button.layer.masksToBounds = true
        button.backgroundColor = .link
        button.layer.borderColor = UIColor.white.cgColor
        button.addTarget(self, action: #selector(onTapLogin), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.title = "Log In"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(didTapRegister))
        
        emailTF.delegate = self
        passwordTF.delegate = self
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailTF)
        scrollView.addSubview(passwordTF)
        scrollView.addSubview(loginBtn)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        scrollView.frame = view.bounds
        
        let size = scrollView.width/3
        imageView.frame = CGRect(x: (scrollView.width-size)/2,
                                 y: 20,
                                 width: size,
                                 height: size)
        emailTF.frame = CGRect(x: 30,
                               y: imageView.bottom+15,
                               width: scrollView.width-60,
                               height: 52)
        passwordTF.frame = CGRect(x: 30,
                                  y: emailTF.bottom+10,
                                  width: scrollView.width-60,
                                  height: 52)
        loginBtn.frame = CGRect(x: 30,
                                y: passwordTF.bottom+25,
                                width: scrollView.width-60,
                                height: 52)
        
    }
    
    @objc private func didTapRegister(){
        let vc = RegistrationVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func onTapLogin(){
        
        emailTF.resignFirstResponder()
        passwordTF.resignFirstResponder()
        
        guard let email = emailTF.text, let password = passwordTF.text, !email.isEmpty, !password.isEmpty, password.count >= 6 else{
            alertUserLoginError()
            return
        }
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) {[weak self] (authResult, error) in
            
            guard let self = self else{return}
            
            guard let result = authResult, error == nil else{
                print("error in login user")
                return
            }
            
            let user = result.user
            print("Logged in successfully \(user.uid)")
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
        
    }
    
    @objc func alertUserLoginError() {
        let alert = UIAlertController(title: "oops..",
                                      message: "fields are empty to login",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
}

extension LoginVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailTF {
            passwordTF.becomeFirstResponder()
        }else if textField == passwordTF {
            onTapLogin()
        }
        return true
    }
    
}
