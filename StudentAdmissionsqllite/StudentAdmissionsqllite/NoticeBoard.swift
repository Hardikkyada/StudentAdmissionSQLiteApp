//
//  NoticeBoard.swift
//  StudentAdmissionsqllite
//
//  Created by DCS on 17/07/21.
//  Copyright © 2021 HRK. All rights reserved.
//

import UIKit

class NBoard: UIViewController {

    private let mytableview = UITableView()
    
    private var loaddata = [Noticedata]()
    
    let user = UserDefaults.standard.string(forKey: "user")
    
    private let namelabel:UILabel = {
        let lab = UILabel()
        lab.text = ""
        lab.textAlignment = .center
        //lab.backgroundColor = UIColor.gray
        return lab
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "NoticeBoard"
        self.view.backgroundColor = .white
        
        
        if user == "Admin"{
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
        }
        
        
        view.addSubview(namelabel)
        view.addSubview(mytableview)
        
        setuptable()
        mytableview.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        loaddata = Noticedatahandlar.shared.fetch()
        mytableview.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        mytableview.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.height-view.safeAreaInsets.top - (mytableview.top + 50))
        
    }
    
    @objc func add(){
        let vc = Addnoti()
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension NBoard:UITableViewDataSource,UITableViewDelegate{
    
    func setuptable(){
        mytableview.dataSource = self
        mytableview.delegate = self
        mytableview.register(UITableViewCell.self, forCellReuseIdentifier: "loaddata")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loaddata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "loaddata", for: indexPath)
        cell.textLabel?.text = loaddata[indexPath.row].conten
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(user == "Admin")
        {
            let vc = Addnoti()
            vc.updatedata = loaddata[indexPath.row].conten
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if(user == "Admin")
        {
            if editingStyle == .delete{
                mytableview.beginUpdates()
                
                let id = loaddata[indexPath.row].id
                
                Noticedatahandlar.shared.delete(id: id){ [weak self] success in
                    
                    if success{
                        let alert = UIAlertController(title: "Success..", message: "Notice Delete successfull", preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alert.addAction(action)
                        
                        DispatchQueue.main.async {
                            self?.present(alert, animated: true, completion: nil)
                            self?.loaddata.remove(at: indexPath.row)
                            tableView.deleteRows(at: [indexPath], with: .fade)
                        }
                        
                    }else{
                        let alert = UIAlertController(title: "Failed..", message: "Notice is Not Delete", preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alert.addAction(action)
                        
                        DispatchQueue.main.async {
                            self?.present(alert, animated: true, completion: nil)
                        }
                        
                    }
                }
                mytableview.endUpdates()
                mytableview.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

