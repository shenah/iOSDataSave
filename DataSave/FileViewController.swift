//
//  FileViewController.swift
//  DataSave
//
//  Created by 503-03 on 2018. 11. 13..
//  Copyright © 2018년 shenah. All rights reserved.
//

import UIKit

class FileViewController: UIViewController {

    var fileMgr : FileManager = FileManager.default
    var docsDir : String?
    var filePath : String?
    
    @IBOutlet weak var tf: UITextField!
    
    @IBAction func read(_ sender: Any) {
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        docsDir = dirPaths[0]
        filePath = docsDir! + "/data.dat"
        // 파일의 존재 여부를 확인
        if fileMgr.fileExists(atPath: filePath!) == false{
            tf.text = "파일이 존재하지 않습니다."
        }else{
            //FileManager로 데이터(byte 배열) 읽어오기
            let data = fileMgr.contents(atPath: filePath!)
            let str = NSString.init(data: data!, encoding: String.Encoding.utf8.rawValue)
            tf.text = str! as String
        }
    }
    
    @IBAction func write(_ sender: Any) {
        //도큐먼트 디렉토리 생성
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        docsDir = dirPaths[0]
        //파일 경로 생성
        filePath = docsDir! + "/data.dat"
        
        //textfield의 text 가져오기
        let str = tf.text
        //text 데이터를 인코딩 처리
        let databuffer = str!.data(using: String.Encoding.utf8)
        
        //파일 생성
        fileMgr.createFile(atPath: filePath!, contents: databuffer, attributes: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
