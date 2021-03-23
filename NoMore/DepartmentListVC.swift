//
//  DepartmentListVC.swift
//  NoMore
//
//  Created by 이철민 on 2021/02/02.
//

import Foundation
import UIKit

class DepartmentListVC: UITableViewController {
    var departList: [(departCd: Int, departTitle: String)]!
    let departDAO = DepartmentDAO()
    
    func initUI() {
        let navTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 60))
        navTitle.numberOfLines = 2
        navTitle.textAlignment = .center
        navTitle.font = UIFont.systemFont(ofSize: 14)
        navTitle.text = "안내소 목록 \n" + "총 \(self.departList.count)"
        
        self.navigationItem.titleView = navTitle
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        self.tableView.allowsSelectionDuringEditing = true
    }
    
    override func viewDidLoad() {
        self.departList = self.departDAO.find()
        self.initUI()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.departList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowData = self.departList[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DEPART_CELL")
        
        cell?.textLabel?.text = rowData.departTitle
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
        
        cell?.detailTextLabel?.text = "\(rowData.departCd)"
        cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 12)
        
        return cell!
    }
    
    @IBAction func add(_ sender: Any) {
        let alert = UIAlertController(title: "신규 안내소", message: "등록", preferredStyle: .alert)
        
        alert.addTextField() { (tf) in tf.placeholder = "안내소명"}
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "확인", style: .default) { (_) in
            let title = alert.textFields?[0].text
            
            if self.departDAO.create(title: title!) {
                self.departList = self.departDAO.find()
                self.tableView.reloadData()
                
                let navTitle = self.navigationItem.titleView as! UILabel
                navTitle.text = "안내소 목록 \n" + "\(self.departList.count)"
            }
        })
        self.present(alert, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let departCd = self.departList[indexPath.row].departCd
        
        if departDAO.remove(departCd: departCd) {
            self.departList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let departCd = self.departList[indexPath.row].departCd
        let infoVC = self.storyboard?.instantiateViewController(withIdentifier: "DEPART_INFO")
        
        if let _infoVC = infoVC as? DepartmentInfoVC {
            _infoVC.departCd = departCd
            self.navigationController?.pushViewController(_infoVC, animated: true)
        }
    }
}
