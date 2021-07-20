//
//  StudPenal.swift
//  StudentAdmissionsqllite
//
//  Created by DCS on 17/07/21.
//  Copyright © 2021 HRK. All rights reserved.
//

import UIKit

class StudPenal: UIViewController {

    private var loaddata = [Studdata]()
    
    var sname = ""
    var userpwd = ""
    let dateformat = DateFormatter()
    
    private let id:UILabel = {
        let textf = UILabel()
        textf.textAlignment = .center
        textf.layer.borderWidth = 5
        textf.font = UIFont.boldSystemFont(ofSize: 20)
        return textf
    }()
    
    private let name:UILabel = {
        let textf = UILabel()
        
        textf.textAlignment = .center
        
        textf.layer.borderWidth = 5
        textf.font = UIFont.boldSystemFont(ofSize: 20)
        return textf
    }()
    
    
    private let dob:UILabel = {
        let textf = UILabel()
        
        textf.textAlignment = .center
        
        textf.layer.borderWidth = 5
        textf.font = UIFont.boldSystemFont(ofSize: 20)
        return textf
    }()
    
    private let classname:UILabel = {
        let textf = UILabel()
        
        textf.textAlignment = .center
        
        textf.layer.borderWidth = 5
        textf.font = UIFont.boldSystemFont(ofSize: 20)
        return textf
    }()
    
    
    private let logout:UIButton = {
        let btn = UIButton()
        btn.setTitle("Logout", for: .normal)
        btn.addTarget(self, action: #selector(logoutaction), for: .touchUpInside)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.backgroundColor = UIColor.init(red: 0, green: 255, blue: 0, alpha: 0.6)
        btn.layer.cornerRadius = 10
        return btn
    }()
    
    private let NoticBoard:UIButton = {
        let btn = UIButton()
        btn.setTitle("NoticBoard", for: .normal)
        btn.addTarget(self, action: #selector(NBaction), for: .touchUpInside)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.backgroundColor = UIColor.init(red: 0, green: 255, blue: 0, alpha: 0.6)
        btn.layer.cornerRadius = 10
        return btn
    }()
    
    private let changepwd:UIButton = {
        let btn = UIButton()
        btn.setTitle("Change Password", for: .normal)
        btn.addTarget(self, action: #selector(pwdaction), for: .touchUpInside)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.backgroundColor = UIColor.init(red: 0, green: 255, blue: 0, alpha: 0.6)
        btn.layer.cornerRadius = 10
        return btn
    }()
    
    @objc func logoutaction(){
        
        UserDefaults.standard.removeObject(forKey: "user")
        UserDefaults.standard.removeObject(forKey: "spid")
        UserDefaults.standard.removeObject(forKey: "pwd")
        UserDefaults.standard.removeObject(forKey: "studname")
        print("logout")
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc func NBaction(){
        let vc = NBoard()
        navigationController?.pushViewController(vc,animated: true)
    }
    
    @objc func pwdaction(){
        let alert = UIAlertController(title: "Enter Detailes", message: "", preferredStyle: .alert)
        
        alert.addTextField { (tf) in
            tf.placeholder = "Enter New Password"
            tf.text = self.userpwd
            
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            
            let pwd = alert.textFields![0]
            self.pwdchnage(pass: pwd.text!)
        }))
        self.present(alert,animated :true,completion: nil)
    }
    
    func pwdchnage(pass:String)
    {
        let n = loaddata.count
        
        for i in 0..<n
        {
            if(loaddata[i].pwd == userpwd)
            {
                let studarray = Studdata(spid: loaddata[i].spid, name: loaddata[i].name, pwd: pass,dob: loaddata[i].dob ,classname: loaddata[i].classname)
                
                Datahandlar.shared.changepass(stud: studarray){ [weak self] success in
                    
                    if success{
                        let alert = UIAlertController(title: "Success..", message: "Change Password successfull", preferredStyle: .alert)
                        let action = UIAlertAction(title: "Again Login", style: .cancel, handler: nil)
                        alert.addAction(action)
                        
                        DispatchQueue.main.async {
                            self?.present(alert, animated: true, completion: nil)
                            
                        }
                        self?.navigationController?.popViewController(animated: true)
                        
                    }else{
                        let alert = UIAlertController(title: "Failed..", message: "Password is not change", preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alert.addAction(action)
                        
                        DispatchQueue.main.async {
                            self?.present(alert, animated: true, completion: nil)
                        }
                        
                    }
                }
            }
        }
    }
    
    func datetostring(dob:Date) -> String{
        let dobdate = dob
        dateformat.dateFormat = "d MMM y"
        return dateformat.string(from: dobdate)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        sname = UserDefaults.standard.value(forKey: "studname") as! String
        userpwd = UserDefaults.standard.value(forKey: "pwd") as! String
        
        title = "Welcome \(sname)"
        
        view.addSubview(id)
        view.addSubview(name)
        view.addSubview(dob)
        view.addSubview(logout)
        view.addSubview(NoticBoard)
        view.addSubview(changepwd)
        view.addSubview(classname)
        
        let spid = UserDefaults.standard.value(forKey: "spid") as! String
        loaddata = Datahandlar.shared.fetch()
        print(loaddata)
        let n = loaddata.count
        
        for i in 0..<n{
            if(String(loaddata[i].spid) == spid){
                id.text = "ID is :- " + loaddata[i].spid
                name.text = "Name :- " + loaddata[i].name
                /*let dobdate = loaddata[i].dob
                dateformat.dateFormat = "d MMM y"*/
                //dob.text = "DOB :- " + dateformat.string(from: dobdate)
                dob.text = "DOB :- " + loaddata[i].dob
                classname.text = "Class :- " + loaddata[i].classname
            }
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        id.frame = CGRect(x: 40, y: view.safeAreaInsets.top + 20, width: view.width - 80, height: 60)
        name.frame = CGRect(x: 40, y: id.bottom + 20, width: view.width - 80, height: 60)
        
        classname.frame = CGRect(x: 40, y: name.bottom + 20, width: view.width - 80, height: 60)
        dob.frame = CGRect(x: 40, y: classname.bottom + 20, width: view.width - 80, height: 60)
        
        NoticBoard.frame = CGRect(x: 20, y: dob.bottom + 50, width: view.width - 60, height: 40)
        
        changepwd.frame = CGRect(x: 20, y: NoticBoard.bottom + 5, width: view.width - 60, height: 40)
        
        logout.frame = CGRect(x: 20, y: changepwd.bottom + 5, width: view.width - 60, height: 40)
        
    }
    
}
