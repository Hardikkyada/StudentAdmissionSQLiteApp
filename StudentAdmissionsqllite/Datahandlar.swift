//
//  Datahandlar.swift
//  StudentAdmissionsqllite
//
//  Created by DCS on 17/07/21.
//  Copyright © 2021 HRK. All rights reserved.
//

import Foundation
import SQLite3

class Datahandlar
{
    static let shared = Datahandlar()
    
    let dbpath = "StudentDB.sqlite"
    var db:OpaquePointer?
    
    private init(){
        db = opendb()
        createtable()
        //deletetable()
    }
    
    func opendb() -> OpaquePointer?{
        let docurl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let fileurl = docurl.appendingPathComponent(dbpath)
        print(fileurl)
        var database:OpaquePointer? = nil
        
        if sqlite3_open(fileurl.path, &database) == SQLITE_OK{
            print("connected")
            return database
        }else{
            print("Not connection with database")
            return nil
        }
    }
    
    func createtable(){
        let cmd = """
        CREATE TABLE IF NOT EXISTS Student(
        spid TEXT,
        name TEXT,
        pwd TEXT,
        dob TEXT,
        classname TEXT
        );
        """
        var cmdstatement:OpaquePointer? =  nil
        
        if sqlite3_prepare_v2(db, cmd, -1, &cmdstatement, nil) == SQLITE_OK{
            
            if sqlite3_step(cmdstatement) == SQLITE_DONE{
                print("Table create...")
            }else{
                print("Error in creating Table...!!")
            }
        }else{
            print("Problem in create table prepare...")
        }
        sqlite3_finalize(cmdstatement)
    }
    
    func insert(stud:Studdata,complition: @escaping ((Bool) -> Void)){
        let cmd = "INSERT INTO Student(spid,name,pwd,dob,classname) values(?,?,?,?,?)"
        var cmdstatement:OpaquePointer? =  nil
        
        if sqlite3_prepare_v2(db, cmd, -1, &cmdstatement, nil) == SQLITE_OK{
            sqlite3_bind_text(cmdstatement, 1,(stud.spid as NSString).utf8String, -1, nil)
            sqlite3_bind_text(cmdstatement, 2,(stud.name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(cmdstatement, 3,(stud.pwd as NSString).utf8String, -1, nil)
            
            /*let dateformat = DateFormatter()
            dateformat.dateFormat = "d MMM y"
            let dob = dateformat.string(from: stud.dob)*/
            
            sqlite3_bind_text(cmdstatement, 4,(stud.dob as NSString).utf8String, -1, nil)
            
            sqlite3_bind_text(cmdstatement, 5,(stud.classname as NSString).utf8String, -1, nil)
            
            if sqlite3_step(cmdstatement) == SQLITE_DONE{
                print("Insert data in table")
                complition(true)
            }else{
                print("data is not insert in table")
                complition(false)
            }
        }else{
            print("Can not prepare insert statement")
        }
        sqlite3_finalize(cmdstatement)
    }
    
    
    func update(stud:Studdata,complition: @escaping ((Bool) -> Void)){
        
        let cmd = "UPDATE Student SET name = ?,pwd = ?,classname = ?,dob = ? WHERE spid = ?"
        var cmdstatement:OpaquePointer? =  nil
        
        if sqlite3_prepare_v2(db, cmd, -1, &cmdstatement, nil) == SQLITE_OK{
            
            sqlite3_bind_text(cmdstatement, 1,(stud.name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(cmdstatement, 2,(stud.pwd as NSString).utf8String, -1, nil)
            sqlite3_bind_text(cmdstatement, 3,(stud.classname as NSString).utf8String, -1, nil)

            
            sqlite3_bind_text(cmdstatement, 4,(stud.dob as NSString).utf8String, -1, nil)
            
            sqlite3_bind_text(cmdstatement, 5,(stud.spid as NSString).utf8String, -1, nil)
            
            if sqlite3_step(cmdstatement) == SQLITE_DONE{
                print("Update data sccessfull")
                complition(true)
            }else{
                print("data is not update")
                complition(false)
            }
        }else{
            print("Can not prepare update statement")
        }
        
        sqlite3_finalize(cmdstatement)
    }
    
    func fetch() -> [Studdata]{
        let cmd = "select * from Student"
        var cmdstatement:OpaquePointer? =  nil
        
        var studarray = [Studdata]()
        if sqlite3_prepare_v2(db, cmd, -1, &cmdstatement, nil) == SQLITE_OK{
            
            while sqlite3_step(cmdstatement) == SQLITE_ROW{
                let spid = String(cString:sqlite3_column_text(cmdstatement, 0))
                let name = String(cString:sqlite3_column_text(cmdstatement, 1))
                let pwd = String(cString:sqlite3_column_text(cmdstatement, 2))
                let dob = String(cString:sqlite3_column_text(cmdstatement, 3))
                let classname = String(cString:sqlite3_column_text(cmdstatement, 4))
                
               /* let dateformat = DateFormatter()
                dateformat.dateFormat = "d MMM y"
                let ddob = dateformat.date(from: dob)!*/
                
                studarray.append(Studdata(spid: spid, name: name, pwd: pwd,dob: dob,classname: classname))
                
                print("data is :- \(spid)\(name)\(pwd)\(classname)\(dob)")
            }
        }else{
            print("Can not prepare select statement")
        }
        
        sqlite3_finalize(cmdstatement)
        return studarray
    }
    
    
    func delete(id:String,complition: @escaping ((Bool) -> Void)){
        let cmd = "delete from Student where spid = ?"
        var cmdstatement:OpaquePointer? =  nil
        
        if sqlite3_prepare_v2(db, cmd, -1, &cmdstatement, nil) == SQLITE_OK{
            
            sqlite3_bind_text(cmdstatement, 1,(id as NSString).utf8String, -1, nil)
            
            if sqlite3_step(cmdstatement) == SQLITE_DONE{
                print("Data is Deleted...")
                complition(true)
            }else{
                print("data is not delete")
                complition(false)
            }
        }else{
            print("Can not prepare delete statement")
        }
        sqlite3_finalize(cmdstatement)
    }
    
    func deletetable(){
        let cmd = "drop table Student"
        var cmdstatement:OpaquePointer? =  nil
        
        if sqlite3_prepare_v2(db, cmd, -1, &cmdstatement, nil) == SQLITE_OK{
            
            if sqlite3_step(cmdstatement) == SQLITE_DONE{
                print("Data is Deleted...")
                
            }else{
                print("data is not delete")
               
            }
        }else{
            print("Can not prepare delete table statement")
        }
        sqlite3_finalize(cmdstatement)
    }
    
    func changepass(stud:Studdata,complition: @escaping ((Bool) -> Void)){
        let cmd = "update Student set pwd = ? where spid = ?"
        var cmdstatement:OpaquePointer? =  nil
        
        if sqlite3_prepare_v2(db, cmd, -1, &cmdstatement, nil) == SQLITE_OK{
            
            sqlite3_bind_text(cmdstatement, 1,(stud.pwd as NSString).utf8String, -1, nil)
            sqlite3_bind_text(cmdstatement, 2,(stud.spid as NSString).utf8String, -1, nil)
           
            if sqlite3_step(cmdstatement) == SQLITE_DONE{
                print("change Password sccessfull")
                complition(true)
            }else{
                print("Not change password Try again")
                complition(false)
            }
        }else{
            print("Can not prepare passchange statement")
        }
        
        sqlite3_finalize(cmdstatement)
    }
    
    
    func select(q:String,stud:Studdata) -> [Studdata]{
        let cmd = q
        var cmdstatement:OpaquePointer? =  nil
        
        var studarray = [Studdata]()
        
        if sqlite3_prepare_v2(db, cmd, -1, &cmdstatement, nil) == SQLITE_OK{
            
            while sqlite3_step(cmdstatement) == SQLITE_ROW{
                let spid = String(cString:sqlite3_column_text(cmdstatement, 1))
                let name = String(cString:sqlite3_column_text(cmdstatement, 2))
                let pwd = String(cString:sqlite3_column_text(cmdstatement, 3))
                let classname = String(cString:sqlite3_column_text(cmdstatement, 4))
                let dob = String(cString:sqlite3_column_text(cmdstatement, 5))
                
               /* let dateformat = DateFormatter()
                dateformat.dateFormat = "d MMM y"
                let ddob = dateformat.date(from: dob)!*/
                
                studarray.append(Studdata(spid: spid, name: name, pwd: pwd, dob: dob,classname: classname))
                
                print("data is :- \(spid)\(name)\(pwd)\(classname)\(dob)")
            }
        }else{
            print("Can not prepare select query statement")
        }
        
        sqlite3_finalize(cmdstatement)
        return studarray
    }
}
