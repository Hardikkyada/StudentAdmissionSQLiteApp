//
//  StudentClass.swift
//  StudentAdmissionsqllite
//
//  Created by DCS on 17/07/21.
//  Copyright © 2021 HRK. All rights reserved.
//

import Foundation

class Studdata{
    var spid:String
    var name:String
    var pwd:String
    var dob:String
    var classname:String
    
    init(spid:String,name:String,pwd:String,dob:String,classname:String){
        self.spid = spid
        self.name = name
        self.classname = classname
        self.pwd = pwd
        self.dob = dob
    }
}
