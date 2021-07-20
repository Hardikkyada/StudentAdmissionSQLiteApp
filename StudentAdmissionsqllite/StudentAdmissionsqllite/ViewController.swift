//
//  ViewController.swift
//  StudentAdmissionsqllite
//
//  Created by DCS on 17/07/21.
//  Copyright © 2021 HRK. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var stddata = [Studdata]()
    
    private let id:UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter ID"
        textField.textAlignment = .center
        textField.borderStyle = .roundedRect
        //textField.layer.cornerRadius = 5
        //textField.backgroundColor = UIColor.gray
        textField.textColor = UIColor.black
        return textField
    }()
    
    private let pass:UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Password"
        textField.textAlignment = .center
        textField.borderStyle = .roundedRect
        //textField.backgroundColor = UIColor.gray
        textField.textColor = UIColor.black
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let Login:UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.backgroundColor = UIColor.init(red: 0, green: 255, blue: 0, alpha: 0.6)
        button.addTarget(self, action: #selector(login), for: .touchUpInside)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    @objc func login(){
        let n = stddata.count
        if(id.text == "Admin" && pass.text == "123"){
            UserDefaults.standard.set("Admin", forKey: "user")
            let vc = AdminPenal()
            navigationController?.pushViewController(vc, animated: true)
        }
        else{
    
            for i in 0..<n{
                
                if(id.text == stddata[i].spid && pass.text == stddata[i].pwd){
                    
                    UserDefaults.standard.set("Student", forKey: "user")
                    UserDefaults.standard.set(id.text, forKey: "spid")
                    UserDefaults.standard.set(pass.text, forKey: "pwd")
                    UserDefaults.standard.set(stddata[i].name, forKey: "studname")
                    
                    let vc = StudPenal()
                    navigationController?.pushViewController(vc, animated: true)
                    break
                }
                    
                else if(i == n-1)
                {
                    let alert = UIAlertController(title: "Wornge..", message: "Enter valid Id and Passworrd", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alert.addAction(action)
                    
                    DispatchQueue.main.async {
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
        id.text = ""
        pass.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"
        print("login")
        
        
        //self.view.backgroundColor = .white
        
        let img = UIImageView(frame: view.bounds)
        img.image = UIImage(named: "login3")
        view.addSubview(img)
        
        /*
        let img = UIImageView(frame: UIScreen.main.bounds)
        img.image = UIImage(named: "login2")
        img.contentMode = UIView.ContentMode.scaleToFill
        self.view.insertSubview(img, at: 0)*/
    
        
        //view.backgroundColor = UIColor(patternImage: UIImage(named: "login2")!)
        
        // Do any additional setup after loading the view.
        
        view.addSubview(Login)
        view.addSubview(pass)
        view.addSubview(id)
        
        
        let bckimage = UIImageView(frame: UIScreen.main.bounds)
        bckimage.image = UIImage(named: "4")
        bckimage.contentMode = UIView.ContentMode.scaleToFill
        self.view.insertSubview(bckimage, at: 0)
        
        stddata = Datahandlar.shared.fetch()
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        let userder = UserDefaults.standard.string(forKey: "session_id")
        
        if(userder != nil){
            print("login jemp")
            
        }
        stddata = Datahandlar.shared.fetch()
        print(stddata)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        id.frame = CGRect(x: 20, y: (view.height/2) - 50, width: view.width-40, height: 40)
        pass.frame = CGRect(x: 20, y: id.bottom + 20, width: view.width-40, height: 40)
        Login.frame = CGRect(x: 20, y: pass.bottom + 40, width: view.width-40, height: 40)
    }
    
    
}
