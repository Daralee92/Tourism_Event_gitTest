//
//  ItemDAO.swift
//  NoMore
//
//  Created by 이철민 on 2021/02/02.
//

import Foundation
import UIKit

struct ItemVO {
    var itemCd = 0
    var itemName = ""
    var itemCount = 0
    var departCd = 0
    var departTitle = ""
}
class ItemDAO {
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
    
    func find(departCd: Int = 0) -> [ItemVO] {
        var itemList = [ItemVO]()
        
        do {
            let condition = departCd == 0 ? "" : "WHERE item.depart_cd = \(departCd)"
            let sql = """
            SELECT item_cd, item_name, item_count, department.depart_title
            FROM item
            JOIN department On department.depart_cd = item.depart_cd
            \(condition)
            ORDER BY item.depart_cd ASC
            """
        
            let rs = try self.fmdb.executeQuery(sql, values: nil)
        
            while rs.next() {
                var record = ItemVO()
            
                record.itemCd = Int(rs.int(forColumn: "item_cd"))
                record.itemName = rs.string(forColumn: "item_name")!
                record.itemCount = Int(rs.int(forColumn: "item_count"))
                record.departTitle = rs.string(forColumn: "depart_title")!
            
                itemList.append(record)
            }
        } catch let error as NSError {
            print("failed: \(error.localizedDescription)")
        }
        return itemList
    }
    
    func get(itemCd: Int) -> ItemVO? {
        let sql = """
        SELECT item_cd, item_name, item_count, department.depart_title
        FROM item
        JOIN department On department.depart_cd = item.depart_cd
        WHERE item_cd = ?
        """
        
        let rs = self.fmdb.executeQuery(sql, withArgumentsIn: [itemCd])
        
        if let _rs = rs {
            _rs.next()
            
            var record = ItemVO()
            record.itemCd = Int(_rs.int(forColumn: "item_cd"))
            record.itemName = _rs.string(forColumn: "item_name")!
            record.itemCount = Int(_rs.int(forColumn: "item_count"))
            record.departTitle = _rs.string(forColumn: "depart_title")!
            
            return record
        } else {
            return nil
        }
    }
    
    func create(param: ItemVO) -> Bool {
        do {
            let sql = """
            INSERT INTO item (item_name, item_count, depart_cd)
            VALUES (?, ?, ?)
            """
            
            var params = [Any]()
            params.append(param.itemName)
            params.append(param.itemCount)
            params.append(param.departCd)
            
            try self.fmdb.executeUpdate(sql, values: params)
            
            return true
        } catch let error as NSError {
            print("Insert Error: \(error.localizedDescription)")
            return false
        }
    }
    
    func remove(itemCd: Int) -> Bool {
        do {
            let sql = "DELETE FROM item WHERE item_cd = ?"
            try self.fmdb.executeUpdate(sql, values: [itemCd])
            return true
        } catch let error as NSError {
            print("Insert Error: \(error.localizedDescription)")
            return false
        }
    }
}
