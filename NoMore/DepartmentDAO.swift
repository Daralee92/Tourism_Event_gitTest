//
//  DepartmentDAO.swift
//  NoMore
//
//  Created by 이철민 on 2021/02/02.
//

import Foundation
import UIKit

class DepartmentDAO {
    typealias DepartRecord = (Int, String)
    
    lazy var fmdb: FMDatabase! = {
        let fileMgr = FileManager.default
        
        let docPath = fileMgr.urls(for: .documentDirectory, in: .userDomainMask).first
        let dbPath = docPath!.appendingPathComponent("hr.sqlite").path
        
        if fileMgr.fileExists(atPath: dbPath) == false {
            let dbSource = Bundle.main.path(forResource: "hr", ofType: "sqlite")
            try! fileMgr.copyItem(atPath: dbSource!, toPath: dbPath)
        }
        
        let db = FMDatabase(path: dbPath)
        return db
    }()
    
    init() {
        self.fmdb.open()
    }
    deinit {
        self.fmdb.close()
    }
    
    func find() -> [DepartRecord] {
        var departList = [DepartRecord]()
        
        do {
            let sql = """
            SELECT depart_cd, depart_title
            FROM department
            ORDER BY depart_cd ASC
            """
            
            let rs = try self.fmdb.executeQuery(sql, values: nil)
            
            while rs.next() {
                let departCd = rs.int(forColumn: "depart_cd")
                let departTitle = rs.string(forColumn: "depart_title")
                
                departList.append((Int(departCd), departTitle!))
            }
        } catch let error as NSError {
            print("failed: \(error.localizedDescription)")
        }
        return departList
    }
    
    func get(departCd: Int) -> DepartRecord? {
        let sql = """
        SELECT depart_cd, depart_title
        FROM department
        WHERE depart_cd = ?
        """
        
        let rs = self.fmdb.executeQuery(sql, withArgumentsIn: [departCd])
        
        if let _rs = rs {
            _rs.next()
            
            let departId = _rs.int(forColumn: "depart_cd")
            let departTitle = _rs.string(forColumn: "depart_title")
            
            return (Int(departId), departTitle!)
        } else {
            return nil
        }
    }
    
    func create(title: String!) -> Bool {
        do {
            let sql = """
            INSERT INTO department (depart_title)
            VALUES (?)
            """
            
            try self.fmdb.executeUpdate(sql, values: [title!])
            return true
        } catch let error as NSError {
            print("Insert Error: \(error.localizedDescription)")
            return false
        }
    }
    
    func remove(departCd: Int) -> Bool {
        do {
            let sql = "DELETE FROM department WHERE depart_cd = ?"
            try self.fmdb.executeUpdate(sql, values: [departCd])
            return true
        } catch let error as NSError {
            print("DELETE Error: \(error.localizedDescription)")
            return false
        }
    }
}
