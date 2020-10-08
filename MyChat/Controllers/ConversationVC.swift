//
//  ViewController.swift
//  MyChat
//
//  Created by vikas on 07/10/20.
//  Copyright © 2020 vikas. All rights reserved.
//

import UIKit

class ConversationVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let logged_In = UserDefaults.standard.bool(forKey: "Logged In")
        
        if !logged_In {
            let vc = LoginVC()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: false, completion: nil)
        }
        
    }
    


}

