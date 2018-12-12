//
//  ViewController.swift
//  FileHandleUse
//
//  Created by 503-03 on 2018. 11. 14..
//  Copyright © 2018년 shenah. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var tf: UITextField!
    @IBAction func readText(_ sender: Any) {
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docDir = dirPaths[0]
        let filePath = docDir + "/data.dat"
        let file : FileHandle? = FileHandle.init(forReadingAtPath: filePath)
        if file == nil {
            tf.text = "읽을 파일이 없습니다."
        }else{
            //바이트 배열인 Data를 읽어오기
            let data = file?.readDataToEndOfFile()
            //화면에 출력하기 위해 바이트 배열를 String으로 변환해준다
            let out = NSString.init(data: data!, encoding: String.Encoding.utf8.rawValue)
            file?.closeFile()
            tf.text = out! as String
        }
    }
    @IBAction func writeText(_ sender: Any) {
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docDir = dirPaths[0]
        let filePath = docDir + "/data.dat"
        let fileMgr = FileManager.default
        //파일 존재 여부를 확인해서 파일이 없으면 생성
        //forUpdatingAtPath - reading and writing
        //forWritingAtPath - writing
        //forReadingAtPath - reading
        var file:FileHandle? = FileHandle.init(forWritingAtPath: filePath)
        if file == nil{
            fileMgr.createFile(atPath: filePath, contents: nil, attributes: nil)
        }
        file = FileHandle.init(forWritingAtPath: filePath)
        //데이터 가져오기
        let stringData = tf.text
        //문자열을 바이트 배열인 Data로 변경해서 기록
        let data = (stringData! as NSString).data(using: String.Encoding.utf8.rawValue)
        file?.seekToEndOfFile()
        file?.write(data!)
        file?.closeFile()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


}

