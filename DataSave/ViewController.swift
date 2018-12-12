//
//  ViewController.swift
//  DataSave
//
//  Created by 503-03 on 2018. 11. 13..
//  Copyright © 2018년 shenah. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var lblemail: UILabel!
    
    @IBAction func next(_ sender: Any) {
        let inputViewController = self.storyboard?.instantiateViewController(withIdentifier: "InputViewController") as! InputViewController
        //트랜지션 애니메이션 설정
        inputViewController.modalTransitionStyle = .coverVertical
        //화면 출력
        self.present(inputViewController, animated: true, completion: nil)

    }
    
    //하위에서 상위로 돌아올 때는 새로 생성하는 것이 아니기에
    //뷰가 화면에 보여질 때 호출되는 메소드
    //하위에서 AppDelegate와 UserDefaults에 저장한 데이터 가져오기 
    override func viewDidAppear(_ animated: Bool) {
        //상위 클래스의 메소드를 호출해야 기능 추가
        super.viewDidAppear(animated)
        
        // AppDelegate 클래스의 인스턴스에 대한 참조 가져오기
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        lblname.text = appDelegate.name
        //UserDefaults 객체에 대한 참조 가져오기
        let userDefaults = UserDefaults.standard
        if let shareText = userDefaults.string(forKey: "email"){
            lblemail.text = shareText
        }
    }
    @IBAction func moveFile(_ sender: Any) {
        let fileViewController = self.storyboard?.instantiateViewController(withIdentifier: "FileViewController") as! FileViewController
        self.present(fileViewController, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


}

