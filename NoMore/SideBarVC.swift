//
//  SideBarVC.swift
//  NoMore
//
//  Created by 이철민 on 2021/02/04.
//

import Foundation
import UIKit

class SideBarVC: UITableViewController {
    let nameLabel = UILabel()
    let profileImage = UIImageView()
    let uinfo = UserInfoManager()
    
    let titles = [ "Event1", "Event2", "Login Page"]
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = "menucell"
        let cell = tableView.dequeueReusableCell(withIdentifier: id) ?? UITableViewCell(style: .default, reuseIdentifier: id)
        
        cell.textLabel?.text = self.titles[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        
        return cell
    }
    
    override func viewDidLoad() {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 70))
        
        headerView.backgroundColor = .brown
        
        self.tableView.tableHeaderView = headerView
        
        self.nameLabel.frame = CGRect(x: 70, y: 15, width: 100, height: 30)
        
        self.nameLabel.textColor = .white
        self.nameLabel.font = UIFont.systemFont(ofSize: 15)
        self.nameLabel.backgroundColor = .clear
        
        headerView.addSubview(self.nameLabel)
        
        self.profileImage.frame = CGRect(x: 10, y: 10, width: 50, height: 50)
        
        self.profileImage.layer.cornerRadius = (self.profileImage.frame.width / 2)
        
        self.profileImage.layer.borderWidth = 0
        self.profileImage.layer.masksToBounds = true
        view.addSubview(self.profileImage)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let uv = self.storyboard?.instantiateViewController(withIdentifier: "Event1")
            let target = self.revealViewController()?.frontViewController as! UINavigationController
            
            target.pushViewController(uv!, animated: true)
            self.revealViewController()?.revealToggle(self)
        } else if indexPath.row == 2 {
            let uv = self.storyboard?.instantiateViewController(withIdentifier: "_Profile")
            uv?.modalPresentationStyle = .fullScreen
            self.present(uv!, animated: true) {
                self.revealViewController()?.revealToggle(self)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.nameLabel.text = self.uinfo.name ?? "Guest"
        self.profileImage.image = self.uinfo.profile
    }
}
