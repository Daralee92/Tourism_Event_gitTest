//
//  ItemNameVC.swift
//  NoMore
//
//  Created by 이철민 on 2021/02/21.
//

import Foundation
import UIKit

class ItemNameVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var tf: UITextField!
    @IBOutlet weak var Label: UILabel!
    var itemList: [ItemVO]!
    var itemDAO = ItemDAO()
    
    
    override func viewDidLoad() {
        // 텍스트 필드 속성 설정
        self.tf.placeholder = "이름을 입력하세요"
        self.tf.keyboardType = UIKeyboardType.alphabet
        self.tf.keyboardAppearance = UIKeyboardAppearance.dark
        self.tf.returnKeyType = UIReturnKeyType.join
        self.tf.enablesReturnKeyAutomatically = true
        
        self.tf.borderStyle = UITextField.BorderStyle.line
        self.tf.backgroundColor = UIColor(white: 0.87, alpha: 1.0)
        self.tf.contentVerticalAlignment = .center
        self.tf.contentHorizontalAlignment = .center
        self.tf.layer.borderColor = UIColor.darkGray.cgColor
        self.tf.layer.borderWidth = 2.0
        self.tf.becomeFirstResponder()
        
        // 델리게이트 지정
        self.tf.delegate = self
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if Int(string) == nil {
            return false
        } else {
            return true
        }
    }
}
