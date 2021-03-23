//
//  DepartmentInfoVC.swift
//  NoMore
//
//  Created by 이철민 on 2021/02/04.
//

import Foundation
import UIKit

class DepartmentInfoVC: UITableViewController {
    typealias DepartRecord = (departCd: Int, departTitle: String)
    
    var departCd: Int!
    let departDAO = DepartmentDAO()
    let itemDAO = ItemDAO()
    
    var departInfo: DepartRecord!
    var itemList: [ItemVO]!
    
    override func viewDidLoad() {
        self.departInfo = self.departDAO.get(departCd: self.departCd)
        self.itemList = self.itemDAO.find(departCd: self.departCd)
        self.navigationItem.title = "\(self.departInfo.departTitle)"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let textHeader = UILabel(frame: CGRect(x: 35, y: 5, width: 200, height: 30))
        textHeader.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight(rawValue: 2.5))
        textHeader.textColor = UIColor(red: 0.03, green: 0.28, blue: 0.71, alpha: 1.0)
        
        if section == 0 {
            textHeader.text = "안내소"
        } else {
            textHeader.text = "기념품"
        }
        
        let v = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        v.backgroundColor = UIColor(red: 0.93, green: 0.96, blue: 0.99, alpha: 1.0)
        
        v.addSubview(textHeader)
        
        return v
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else {
            return self.itemList.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DEPART_CELL")
            
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 13)
            cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 12)
            
            switch indexPath.row {
            case 0 :
                cell?.textLabel?.text = "안내소 코드"
                cell?.detailTextLabel?.text = "\(self.departInfo.departCd)"
            case 1:
                cell?.textLabel?.text = "안내소 이름"
                cell?.detailTextLabel?.text = self.departInfo.departTitle
            default :
                ()
            }
            return cell!
        } else {
            let row = self.itemList[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ITEM_CELL")
            cell?.textLabel?.text = row.itemName
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 12)
            
            cell?.detailTextLabel?.text = "\(row.itemCount)"
            cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 12)
            
            return cell!
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemName = self.itemList[indexPath.row].itemName
        
        let imageVC = self.storyboard?.instantiateViewController(withIdentifier: "image")
        
        if let _imageVC = imageVC as? ImageVC {
            _imageVC.itemName = itemName
            self.navigationController?.pushViewController(_imageVC, animated: true)
        }
    }
}
