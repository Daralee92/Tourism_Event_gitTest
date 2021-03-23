//
//  ItemListVC.swift
//  NoMore
//
//  Created by 이철민 on 2021/02/02.
//

import Foundation
import UIKit

class ItemListVC: UITableViewController {
    var itemList: [ItemVO]!
    var itemDAO = ItemDAO()
    
    func initUI() {
        let navTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 60))
        navTitle.numberOfLines = 2
        navTitle.textAlignment = .center
        navTitle.font = UIFont.systemFont(ofSize: 14)
        navTitle.text = "기념품 목록 \n" + "\(self.itemList.count)"
        
        self.navigationItem.titleView = navTitle
    }
    
    override func viewDidLoad() {
        self.itemList = self.itemDAO.find()
        self.initUI()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.attributedTitle = NSAttributedString(string: "당겨서 새로고침")
        self.refreshControl?.addTarget(self, action: #selector(pullToRefresh(_:)), for: .valueChanged)
    }
    
    @objc func pullToRefresh(_ sender: Any) {
        self.itemList = self.itemDAO.find()
        self.tableView.reloadData()
        
        self.refreshControl?.endRefreshing()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowData = self.itemList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ITEM_CELL")
        
        cell?.textLabel?.text = rowData.itemName + "  " + rowData.departTitle
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
        
        cell?.detailTextLabel?.text = "\(rowData.itemCount)"
        cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 12)
        
        return cell!
    }
    
    @IBAction func add(_ sender: Any) {
        let alert = UIAlertController(title: "기념품 등록", message: "등록해", preferredStyle: .alert)
        
        let pickervc = DepartPickerVC()
        alert.setValue(pickervc, forKey: "contentViewController")
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "확인", style: .default) { (_) in
            var param = ItemVO()
            param.departCd = pickervc.selectedDepartCd
            
            if self.itemDAO.create(param: param) {
                self.itemList = self.itemDAO.find()
                self.tableView.reloadData()
            }
        })
        self.present(alert, animated: true)
    }
    
    @IBAction func editing(_ sender: Any) {
        if self.isEditing == false {
            self.setEditing(true, animated: true)
            (sender as? UIBarButtonItem)?.title = "Done"
        } else {
            self.setEditing(false, animated: true)
            (sender as? UIBarButtonItem)?.title = "Edit"
        }
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let itemCd = self.itemList[indexPath.row].itemCd
        
        if itemDAO.remove(itemCd: itemCd) {
            self.itemList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
