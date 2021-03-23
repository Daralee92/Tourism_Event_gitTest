//
//  FrontPage.swift
//  NoMore
//
//  Created by 이철민 on 2021/02/04.
//

import Foundation
import UIKit

class FrontPage: UIViewController {
    @IBOutlet weak var textField: UITextView!
    
    override func viewDidLoad() {
        if let revealVC = self.revealViewController() {
        
            let btn = UIBarButtonItem()
            btn.image = UIImage(named: "sidemenu.png")
            btn.target = revealVC
            btn.action = #selector(revealVC.revealToggle(_:))
        
            self.navigationItem.leftBarButtonItem = btn
            self.view.addGestureRecognizer(revealVC.panGestureRecognizer())
        }
        
        self.textField.text = "아직 미구현한 부분이 많습니다.\n" + "1. 탭바 on/off 기능 \n" + "2. 물건 수량 카운터 버튼 \n" + "3. 서버 연결 불안정으로 인한 로그인 불가"
    }
}
