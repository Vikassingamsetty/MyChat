//
//  RegistrationVC.swift
//  MyChat
//
//  Created by vikas on 07/10/20.
//  Copyright © 2020 vikas. All rights reserved.
//

import UIKit
import FirebaseAuth

class RegistrationVC: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let profileImage:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person")
        imageView.tintColor = .lightGray
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        return imageView
    }()
    
    private let firstNameTF:UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.placeholder = "firstname..."
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.returnKeyType = .continue
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        return field
    }()
    
    private let lastNameTF:UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.placeholder = "lastname..."
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.returnKeyType = .continue
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        return field
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
    
    private let registerBtn:UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.titleLabel?.textColor = .black
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1
        button.layer.masksToBounds = true
        button.backgroundColor = .systemGreen
        button.layer.borderColor = UIColor.white.cgColor
        button.addTarget(self, action: #selector(onTapSignup), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.title = "Creat Account"
        
        view.addSubview(scrollView)
        scrollView.addSubview(profileImage)
        scrollView.addSubview(firstNameTF)
        scrollView.addSubview(lastNameTF)
        scrollView.addSubview(emailTF)
        scrollView.addSubview(passwordTF)
        scrollView.addSubview(registerBtn)
        
        //TF delegates
        firstNameTF.delegate = self
        lastNameTF.delegate = self
        emailTF.delegate = self
        passwordTF.delegate = self
        
        //tap gesture to imageview
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapImage))
        profileImage.addGestureRecognizer(tap)
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        scrollView.frame = view.bounds
        
        let size = scrollView.width/3
        profileImage.frame = CGRect(x: (scrollView.width-size)/2,
                                    y: 20,
                                    width: size,
                                    height: size)
        profileImage.layer.cornerRadius = profileImage.width / 2.0
        
        firstNameTF.frame = CGRect(x: 30,
                                   y: profileImage.bottom+15,
                                   width: scrollView.width-60,
                                   height: 52)
        lastNameTF.frame = CGRect(x: 30,
                                  y: firstNameTF.bottom+10,
                                  width: scrollView.width-60,
                                  height: 52)
        emailTF.frame = CGRect(x: 30,
                               y: lastNameTF.bottom+10,
                               width: scrollView.width-60,
                               height: 52)
        passwordTF.frame = CGRect(x: 30,
                                  y: emailTF.bottom+10,
                                  width: scrollView.width-60,
                                  height: 52)
        registerBtn.frame = CGRect(x: 30,
                                   y: passwordTF.bottom+25,
                                   width: scrollView.width-60,
                                   height: 52)
        
    }
    
    @objc private func didTapImage(){
        presentPhotoActionSheet()
    }
    
    @objc private func onTapSignup(){
        
        firstNameTF.resignFirstResponder()
        lastNameTF.resignFirstResponder()
        emailTF.resignFirstResponder()
        passwordTF.resignFirstResponder()
        
        guard let fName = firstNameTF.text, let lName = lastNameTF.text,
            let email = emailTF.text, let password = passwordTF.text, !fName.isEmpty, !lName.isEmpty, !email.isEmpty, !password.isEmpty else {
                alertUserLoginError()
                return
        }
        
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            
            guard let result = authResult, error == nil else{
                print("Error in creating user")
                return
            }
            
            let user = result.user
            print("Registered user is \(user)")
            
        }
        
    }
    
    @objc func alertUserLoginError() {
        let alert = UIAlertController(title: "oops..",
                                      message: "fields are empty to signup",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "dismiss", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
}

extension RegistrationVC:UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == firstNameTF {
            lastNameTF.becomeFirstResponder()
        }else if textField == lastNameTF {
            emailTF.becomeFirstResponder()
        }else if textField == emailTF {
            passwordTF.becomeFirstResponder()
        }else if textField == passwordTF {
            onTapSignup()
        }
        return true
    }
    
}

extension RegistrationVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentPhotoActionSheet() {
        
        let actionSheet = UIAlertController(title: "Profile Picture",
                                            message: "How will you access?",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take Photo",
                                            style: .default,
                                            handler: {[weak self] _ in
                                                self?.presentCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo",
                                            style: .default,
                                            handler: {[weak self] _ in
                                                self?.presentGallery()
        }))
        present(actionSheet, animated: true)
    }
    
    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            present(vc, animated: true)
        } else {
            let alertWarning = UIAlertController(title:"Warning", message: "You don't have camera", preferredStyle: .alert)
            alertWarning.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alertWarning, animated: true, completion: nil)
        }
    }
    
    func presentGallery() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {return}
        profileImage.image = imageSelected
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
