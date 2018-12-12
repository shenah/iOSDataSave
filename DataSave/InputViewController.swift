//
//  InputViewController.swift
//  DataSave
//
//  Created by 503-03 on 2018. 11. 13..
//  Copyright © 2018년 shenah. All rights reserved.
//

import UIKit

class InputViewController: UIViewController {

    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    //이전 페이지로 돌아가는 버튼 이벤트
    @IBAction func back(_ sender: Any) {
        //텍스트 필드에 입력한 내용을 AppDelegate와 UserDefaults에 저장하기
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.name = txtName.text!
        let userDefaluts = UserDefaults.standard
        userDefaluts.set(txtEmail.text, forKey: "email")
        
        //이전 뷰 컨트롤러에서 present 메소드로 호출한 경우 돌아가기
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }

    //상위 뷰가 하위 뷰를 present 할 때 새로 생성 되기 때문에 viewDidLoad 메소드 사용 
    //AppDelegate와 UserDefaults에 저장된 데이터를 출력하기
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var appDelegate = UIApplication.shared.delegate as! AppDelegate
        txtName.text = appDelegate.name
        //UserDefaults에 대한 참조 만들기
        let userDefaults = UserDefaults.standard
        if let email = userDefaults.string(forKey: "email"){
            txtEmail.text = email
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
