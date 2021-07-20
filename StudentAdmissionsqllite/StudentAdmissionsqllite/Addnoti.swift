//
//  Addnoti.swift
//  StudentAdmissionsqllite
//
//  Created by DCS on 17/07/21.
//  Copyright © 2021 HRK. All rights reserved.
//

import UIKit

class Addnoti: UIViewController {
    var updatedata = ""
    
    private let datafield:UITextView = {
        let textf = UITextView()
        textf.textAlignment = .center
        textf.layer.borderWidth = 5
        textf.font = UIFont.boldSystemFont(ofSize: 20)
        return textf
    }()
    
    private let save:UIButton = {
        let btn = UIButton()
        btn.setTitle("Save", for: .normal)
        btn.addTarget(self, action: #selector(saveaction), for: .touchUpInside)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.backgroundColor = UIColor.init(red: 0, green: 255, blue: 0, alpha: 0.6)
        btn.layer.cornerRadius = 5
        return btn
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(datafield)
        view.addSubview(save)
        
        if updatedata != ""{
            let data = Noticedatahandlar.shared.fetch()
            let n = data.count
            
            for i in 0..<n{
                if(updatedata == data[i].conten){
                    datafield.text = data[i].conten
                }
            }
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        datafield.frame = CGRect(x: 40, y: view.safeAreaInsets.top + 20, width: view.width - 80, height: 150)
        
        save.frame = CGRect(x: 40, y: datafield.bottom + 20, width: view.width - 80, height: 60)
        
        
    }
    
    @objc func saveaction(){
        if updatedata == ""
        {
            let noticedata = Noticedata(id: 0, conten: datafield.text!)
            Noticedatahandlar.shared.insert(notice: noticedata){ [weak self] success in
                if success{
                    let alert = UIAlertController(title: "Success..", message: "Data Insert successfull", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alert.addAction(action)
                    
                    DispatchQueue.main.async {
                        self?.present(alert, animated: true, completion: nil)
                    }
                    self?.navigationController?.popViewController(animated: true)
                    
                }else{
                    let alert = UIAlertController(title: "Failed..", message: "Data is Not Inserted", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alert.addAction(action)
                    
                    DispatchQueue.main.async {
                        self?.present(alert, animated: true, completion: nil)
                    }
                    
                }
            }
        }else{
            let data = Noticedatahandlar.shared.fetch()
            let n = data.count
            
            for i in 0..<n{
                if(updatedata == data[i].conten){
                    
                    let notitable = Noticedata(id: data[i].id, conten: datafield.text)
                    
                    Noticedatahandlar.shared.update(notice: notitable){ [weak self] success in
                        if success{
                            let alert = UIAlertController(title: "Success..", message: "Data Update successfull", preferredStyle: .alert)
                            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                            alert.addAction(action)
                            
                            DispatchQueue.main.async {
                                self?.present(alert, animated: true, completion: nil)
                                
                            }
                            self?.navigationController?.popViewController(animated: true)
                            
                        }else{
                            let alert = UIAlertController(title: "Failed..", message: "Data is Not Update", preferredStyle: .alert)
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
    }
}
