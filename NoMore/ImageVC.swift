//
//  ImageVC.swift
//  NoMore
//
//  Created by 이철민 on 2021/02/17.
//

import Foundation
import UIKit

class ImageVC: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    var itemName: String!
    var itemList: [ItemVO]!
    
    
    override func viewDidLoad() {
        let backPack = UIImage(named: "account")
        let backPackImage = UIImageView(image: backPack)
        
        let statue = UIImage(named: "account")
        let statueImage = UIImageView(image: statue)
        
        let pocket = UIImage(named: "account")
        let pocketImage = UIImageView(image: pocket)
        
        if self.itemName == "백팩" {
            self.label.text = self.itemName
            self.image = backPackImage
        } else if self.itemName == "조각상" {
            self.label.text = self.itemName
            self.image = statueImage
        } else if self.itemName == "주머니" {
            self.label.text = self.itemName
            self.image = pocketImage
        } else if self.itemName == "공기" {
            self.label.text = self.itemName
            
        }
    }
}
