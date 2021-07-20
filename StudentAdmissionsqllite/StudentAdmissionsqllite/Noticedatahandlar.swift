//
//  Noticedatahandlar.swift
//  StudentAdmissionsqllite
//
//  Created by DCS on 17/07/21.
//  Copyright © 2021 HRK. All rights reserved.
//

import Foundation
import UIKit
import SQLite3


class Noticedatahandlar{
    
    static let shared = Noticedatahandlar()
    let dbpath = "StudentDB.sqlite"
    var db:OpaquePointer?
    
    private init(){
        db = opendb()
        createtable()
    }
    
    func opendb() -> OpaquePointer?{
        let docurl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let fileurl = docurl.appendingPathComponent(dbpath)
        
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
        CREATE TABLE IF NOT EXISTS Notice(
        Id INTEGER PRIMARY KEY AUTOINCREMENT,
        conten TEXT
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
    
    func insert(notice:Noticedata,complition: @escaping ((Bool) -> Void)){
        let cmd = "INSERT INTO Notice(conten) values(?)"
        var cmdstatement:OpaquePointer? =  nil
        
        if sqlite3_prepare_v2(db, cmd, -1, &cmdstatement, nil) == SQLITE_OK{
            
            sqlite3_bind_text(cmdstatement, 1,(notice.conten as NSString).utf8String, -1, nil)
            
           
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
    
    
    func update(notice:Noticedata,complition: @escaping ((Bool) -> Void)){
        let cmd = "update Notice set conten = ? where id = ?"
        var cmdstatement:OpaquePointer? =  nil
        
        if sqlite3_prepare_v2(db, cmd, -1, &cmdstatement, nil) == SQLITE_OK{
            print("current data is",notice.conten)
            sqlite3_bind_text(cmdstatement, 1,(notice.conten as NSString).utf8String, -1, nil)
            
            sqlite3_bind_int(cmdstatement, 2, Int32(notice.id))
            
            if sqlite3_step(cmdstatement) == SQLITE_DONE{
                
                print("Update notice data sccessfull")
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
    
    func fetch() -> [Noticedata]{
        let cmd = "select * from Notice"
        var cmdstatement:OpaquePointer? =  nil
        
        var notiarray = [Noticedata]()
        
        if sqlite3_prepare_v2(db, cmd, -1, &cmdstatement, nil) == SQLITE_OK{
            
            while sqlite3_step(cmdstatement) == SQLITE_ROW{
                let id = Int(sqlite3_column_int(cmdstatement, 0))
                let conten = String(cString:sqlite3_column_text(cmdstatement, 1))
                
                notiarray.append(Noticedata(id: id, conten: conten))
                print("data is :- \(id)-\(conten)")
            }
        }else{
            print("Can not prepare select statement")
        }
        
        sqlite3_finalize(cmdstatement)
        return notiarray
    }
    
    
    func delete(id:Int,complition: @escaping ((Bool) -> Void)){
        let cmd = "delete from Notice where id = ?"
        var cmdstatement:OpaquePointer? =  nil
        
        if sqlite3_prepare_v2(db, cmd, -1, &cmdstatement, nil) == SQLITE_OK{
            
            sqlite3_bind_int(cmdstatement, 1,Int32(id))
            
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
    
    
}
