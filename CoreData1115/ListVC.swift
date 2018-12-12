//
//  ListVC.swift
//  CoreData1115
//
//  Created by 503-03 on 2018. 11. 15..
//  Copyright © 2018년 shenah. All rights reserved.
//

import UIKit
import CoreData

class ListVC: UITableViewController {

    //Board Entity의 모든 데이터를 저장할 프로퍼티 생성
    //배열
    lazy var list : [NSManagedObject] = {
        return self.fetch()
    }()
    //데이터를 읽어서 리턴하는 메소드
    func fetch() -> [NSManagedObject]{
        //저장소를 사용하기 위해서 AppDelegate에 대한 포인터를 생성
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //저장소 context 가져오기 - Board Entity
        let context = appDelegate.persistentContainer.viewContext
        //Board Entity에서 데이터 가져오는 객체 - 요청 객체 가져오기
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Board")
        
        //데이터 가져오기
        //try! 예외 발생하면 아무런 처리도 하지 않는다.
        let result = try! context.fetch(fetchRequest)
        
        return result as! [NSManagedObject]
    }
    
    //CoreData에 데이터 추가하는 메소드 
    func save(title: String, content: String) -> Bool{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        //데이터를 삽입하는 관리 객체를 가져오기
        let newData = NSEntityDescription.insertNewObject(forEntityName: "Board", into: context)
        
        //데이터 넣기
        newData.setValue(title, forKey: "title")
        newData.setValue(content, forKey: "content")
        newData.setValue(Date(), forKey: "regdate")
        
        //로그를 추가하는 코드
        //위에서는 Map 방법으로 데이터 삽입
        //VO 방법 사용: 데이터 삽일할 객체를 가져와 VO 데이터 타입으로 형변환
        let log = NSEntityDescription.insertNewObject(forEntityName: "Log", into: context) as! LogMO
        
        //데이트 넣기
        log.regdate = Date()
        log.type = LogType.create.rawValue
        
        //Board 객체와 연결
        (newData as! BoardMO).addToLog(log)
        
        //커밋 & 롤백
        do{
            try context.save()
            //list에 데이터 저장
            list.insert(newData, at: 0)
            return true
        }catch{
            context.rollback()
            return false
        }
        
    }
    
    //CoreData의 데이터를 삭제하느 메소드
    func delete(object: NSManagedObject) -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        //데이터 삭제
        context.delete(object)
        
        //커밋 & 롤백
        do{
            try context.save()
            return true
        }catch{
            context.rollback()
            return false
        }
    }
    
    //CoreData의 데이터를 수정하는 메소드
    func edit(object : NSManagedObject, title: String, content: String) -> Bool{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        //데이터 수정
        object.setValue(title, forKey: "title")
        object.setValue(content, forKey: "content")
        object.setValue(Date(), forKey: "regdate")
        
        
        let log = NSEntityDescription.insertNewObject(forEntityName: "Log", into: context) as! LogMO
        //데이터 저장
        log.regdate = Date()
        log.type = LogType.create.rawValue
        
        //Board 객체와 연결
        (object as! BoardMO).addToLog(log)
        
        //커밋 & 롤백
        do{
            try context.save()
            return true
        }catch{
            context.rollback()
            return false
        }
    }
    
    
    //화면에 게시글을 추가하는 메소드
    
    //오른 쪽 바버튼의 이벤트 처리 selector로 사용
    //@objc func add(_ sender: Any) {
    
    //바버튼 직접 연결
    @IBAction func add(_ sender: Any) {
        //대화상자 생성
        let alert = UIAlertController.init(title: "게시글 추가", message: "제목과 내용을 작성하세요.", preferredStyle: .alert)
        alert.addTextField(configurationHandler: {(tf) in tf.placeholder = "제목"})
        alert.addTextField(configurationHandler: {(tf) in tf.placeholder = "내용"})
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "확인", style: .default
            , handler: {(a) in
                //텍스트 필드의 내용이 nil이면 메소드 수행 종료
                guard let title = alert.textFields?[0].text, let content = alert.textFields?[1].text
                    else{return}
                //nil 이 아니면 데이터 삽입
                self.save(title: title, content: content)
                //테이블 뷰를 다시 출력
                self.tableView.reloadData()
                
        }))
        self.present(alert, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "게시판"
        
        //바버튼을 코드로 생성
        let addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add(_:)))
        self.navigationItem.rightBarButtonItem = addBtn
        
        //편집 버튼을 네비게이션 바의 왼쪽에 설정
        self.navigationItem.leftBarButtonItem = editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return list.count
    }

    // 행의 셀을 만들어준는 메소드
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        //행의 번에 해당하는 데이터 가져오기
        
        let data = list[indexPath.row]
        let title = data.value(forKey: "title") as! String
        let content = data.value(forKey: "content") as! String
        
        cell.textLabel?.text = title
        cell.detailTextLabel?.text = content
        
        return cell
    }
    

    // 셀을 편집할 때 메소드
    // 셀을 삭제할 때
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        //CoreData의 데이터를 삭제하는 메소드를 호출하기 위하여 행 번호의 데이터 가져오기
        let object = list[indexPath.row]
        
        //CoreData의 데이터를 삭제 성공하면
        if self.delete(object: object){
            //list의 데이터 삭제
            list.remove(at: indexPath.row)
            //cell 데이터 삭제
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
 
    }
    
    //셀을 선택했을 때 호출하는 메소드
    //셀 데이터 수정
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //선택한 행의 데이터를 가져오기
        let object = list[indexPath.row]
        //textfield에 기존 내용을 출력하기 위하여
        let title = object.value(forKey: "title") as! String
        let content = object.value(forKey: "content") as! String
        //데이터 수정을 위해 대화상자 생성
        let alert = UIAlertController(title: "게시글 수정", message: "수정할 내용을 입력하세요", preferredStyle: .alert)
        alert.addTextField(configurationHandler: {(tf) in tf.text = title})
        alert.addTextField(configurationHandler: {(tf) in tf.text = content})
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: {(_) in
            guard let title = alert.textFields?[0].text, let content = alert.textFields?[1].text else{
                return
            }
            //coredata의 데이터를 수정하는 메소드 호출하고 성공했으면 cell를 수정
            if self.edit(object: object, title: title , content: content){
                
                //cell의 데이틀 수정
                let cell = tableView.cellForRow(at: indexPath)
                cell?.textLabel?.text = title
                cell?.detailTextLabel?.text = content
                
                //수정한 cell를 첫 번째 행으로 이동
                let firstIndexPath = IndexPath(row: 0, section: 0)
                self.tableView.moveRow(at: indexPath, to: firstIndexPath)
            }
        }))
        
        self.present(alert, animated: true)
    }

    //accessory 버튼을 눌렸을 때 호출되는 메소드
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        //스토리보드에 만든 ViewController 인스턴스를 생성
        let logVC = self.storyboard?.instantiateViewController(withIdentifier: "LogVC") as! LogVC
        
        //넘겨줄 데이터 가져오기
        let boardMO = self.list[indexPath.row] as! BoardMO
        
        logVC.board = boardMO
        
        //화면 출력 아래부터 위로 보조 출력 네비게이션 컨트롤러가 없이도 사용가능 
        self.show(logVC, sender: true)
        //self.navigationController?.pushViewController(logVC, animated: true)
    }
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
