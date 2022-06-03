//
//  EditViewController.swift
//  TravelBook
//
//  Created by Mayu Yonezu on 2022/05/22.
//

import UIKit
import RealmSwift

class EditViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    //パーツ宣言---------------------------------------------
    // CVで企画選択時のボタンの背景画像
    @IBOutlet var titeImage: UIImageView!
    // 行く日程
    //@IBOutlet weak var StartDayPicker: UIDatePicker!
    @IBOutlet var StartDaysTextField: UITextField!
    // 帰る日程
    //@IBOutlet weak var FinishDayPicker: UIDatePicker!
    @IBOutlet var FinishDaysTextField: UITextField!
    //スケジュールを表示させるためのTebleView
    @IBOutlet var tableView: UITableView!
    // 企画のタイトルを入れるためのTextField
    @IBOutlet var titleName: UITextField!
    // ミッションを表示させるためのLabel
    @IBOutlet var missionLabel: UILabel!
    // ミッションを違うものに変更するためのButton
    @IBOutlet var missionUpdateBtn: UIButton!
    //Section選択するためのPicker
    @IBOutlet var SectionTextField: UITextField!
    // 予定の詳細を書くためTextField
    @IBOutlet var detailTextFiled: UITextField!
    // 予定の始まる時間
    //@IBOutlet weak var StartTimePicker: UIDatePicker!
    @IBOutlet var StartTimeTextField: UITextField!
    // 予定の終わりの時間
    //@IBOutlet weak var FinishTimePicker: UIDatePicker!
    @IBOutlet var FinishTimeTextField: UITextField!
    // 予定を追加するためのButton
    //@IBOutlet var addBtn: UIButton!
    
    var saveButtonItem: UIBarButtonItem!
    
    //ミッション-------------------------------------------
    // ミッションが入ったArray
    let missionArray = ["映えな写真を撮る","おしゃれなVlogを撮る","ストーリーを1日10個載せる","YouTuber風な動画を撮って編集","面白写真を撮る"]

    
    //Realm-----------------------------------------------
    let realm = try! Realm()
    var plans = [Plan]()
    var project = [Project]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Navigation装飾
        navigation()
        
        //SaveButton
        saveButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonPressed(_:)))
        self.navigationItem.rightBarButtonItem = saveButtonItem
        
        // 一番初めに表示されるmission
        mission_random()
        
        // TableViewの初期設定
        tableView.delegate = self
        tableView.dataSource = self
        
        let planData = realm.objects(Plan.self)
        print("🟥全てのデータ\(planData)")
        
        
        // 最初に書いてある薄い文字
        StartDaysTextField.placeholder = "StartDays"
        FinishDaysTextField.placeholder = "EndDays"
        StartTimeTextField.placeholder = "Start"
        FinishTimeTextField.placeholder = "End"
        
        // realm初期化
        //try! realm.write {
        //    realm.deleteAll()
        //}
        
        StartDaysTextField.delegate = self
        FinishDaysTextField.delegate = self
        StartTimeTextField.delegate = self
        FinishTimeTextField.delegate = self
        //キーボードをtimePickerに変更
        StartDaysTextField.inputView = timePicker2
        FinishDaysTextField.inputView = timePicker3
        StartTimeTextField.inputView = timePicker
        FinishTimeTextField.inputView = timePicker1

    }
    
    
    
    
    //UIDatePickerをインスタンス化（同じこと書いてるから後でまとめる）
    let timePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = UIDatePicker.Mode.time
        dp.timeZone = NSTimeZone.local
        //時間をJapanese(24時間表記)に変更
        dp.locale = Locale.init(identifier: "ja_JP")
        dp.timeZone = TimeZone(identifier:  "Asia/Tokyo")
        dp.addTarget(self, action: #selector(dateChange), for: .valueChanged)
        //最小単位（分）を設定
        dp.minuteInterval = 10
        return dp
    }()
    @objc func dateChange(){
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        StartTimeTextField.text = "\(formatter.string(from: timePicker.date))"
        }
    
    let timePicker1: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = UIDatePicker.Mode.time
        dp.timeZone = NSTimeZone.local
        //時間をJapanese(24時間表記)に変更
        dp.locale = Locale.init(identifier: "ja_JP")
        dp.timeZone = TimeZone(identifier:  "Asia/Tokyo")
        dp.addTarget(self, action: #selector(dateChange1), for: .valueChanged)
        //最小単位（分）を設定
        dp.minuteInterval = 10
        return dp
    }()
    @objc func dateChange1(){
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        FinishTimeTextField.text = "\(formatter.string(from: timePicker1.date))"
        }
    
    let timePicker2: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = UIDatePicker.Mode.date
        dp.timeZone = NSTimeZone.local
        //時間をJapanese(24時間表記)に変更
        dp.locale = Locale.init(identifier: "ja_JP")
        dp.timeZone = TimeZone(identifier:  "Asia/Tokyo")
        dp.addTarget(self, action: #selector(dateChange2), for: .valueChanged)
        //最小単位（分）を設定
        dp.minuteInterval = 10
        return dp
    }()
    @objc func dateChange2(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        StartDaysTextField.text = "\(formatter.string(from: timePicker2.date))"
        }
    
    let timePicker3: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = UIDatePicker.Mode.date
        dp.timeZone = NSTimeZone.local
        //時間をJapanese(24時間表記)に変更
        dp.locale = Locale.init(identifier: "ja_JP")
        dp.timeZone = TimeZone(identifier:  "Asia/Tokyo")
        dp.addTarget(self, action: #selector(dateChange3), for: .valueChanged)
        //最小単位（分）を設定
        dp.minuteInterval = 10
        return dp
    }()
    @objc func dateChange3(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        FinishDaysTextField.text = "\(formatter.string(from: timePicker3.date))"
        }
    
    
    
    
    
    // NavigationBar装飾
    func navigation(){
        let appearance = UINavigationBarAppearance()
        
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 242/255.0, green: 167/255.0, blue: 167/255.0, alpha: 1.0)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.lightText]
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
        
        getPlanData()
        
    }
    
    
    
    
    
    
    // アルバムを開くためのアクション
    @IBAction func onTappedAlbumBtn(){
        presentPickerController(sourceType: .photoLibrary)
    }
    
    //　アルバムの呼び出しメソッド（アルバムのソースタイプが引数）
    func presentPickerController(sourceType: UIImagePickerController.SourceType){
        if UIImagePickerController.isSourceTypeAvailable(sourceType){
            let picker = UIImagePickerController()
            picker.sourceType = sourceType
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
        }
    }
    
    // 写真が選択された時に呼ばれるメソッド
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]){
        self.dismiss(animated: true, completion: nil)
        titeImage.image = info[.originalImage] as? UIImage
    }
    
    
    
    
    
    // Missionを更新するためのアクション
    @IBAction func mission_update(){
        mission_random()
    }
    
    //　Missionのランダム生成+ラベルに表示
    func mission_random(){
        // missionArrayからランダムに値を取り出す
        let randomMission = missionArray.randomElement()
        // missionLabelに表示させる
        missionLabel.text = randomMission
    }
    
    
    
    
    
    
    // 企画保存
    @objc func saveButtonPressed(_ sender: UIBarButtonItem){
        
        guard let _ = titleName.text,
        let _ = StartDaysTextField.text,
        let _ = FinishDaysTextField.text,
        let _ = missionLabel.text else {return}
        
        saveProject()
        
        // detailTextFieldを初期化する
        //titleName.text = ""
        //StartDaysTextField.text = ""
        //FinishDaysTextField.text = ""
        //missionLabel.text = ""
        
        print("プロジェクト保存")
        
        performSegue(withIdentifier: "goNext", sender: nil)
        
    }
    
    // 企画を保存
    func saveProject(){
        guard let titleText = titleName.text,
        let startDayText = StartDaysTextField.text,
        let finishDayText = FinishDaysTextField.text,
        let missionText = missionLabel.text else { return }
        
        let project = Project()
        project.title = titleText
        project.startDays = startDayText
        project.finishDays = finishDayText
        project.mission = missionText
        
        try! realm.write({
            realm.add(project) // レコードを追加
        })
        print(project)

    }
    
    // "予定を追加"をタップされたとき
    @IBAction func addBtn(){
        guard let _ = detailTextFiled.text,
        let _ = StartTimeTextField.text,
        let _ = FinishTimeTextField.text else {return}
        
        savePlan()
        
        // detailTextFieldを初期化する
        detailTextFiled.text = ""
        StartTimeTextField.text = ""
        FinishTimeTextField.text = ""
        tableView.reloadData()
        print("保存")
    }
    
    // 予定を保存
    func savePlan(){
        guard let planText = detailTextFiled.text,
        let startText = StartTimeTextField.text,
        let finishText = FinishTimeTextField.text else { return }
        
        let plan = Plan()
        plan.planText = planText
        plan.startTime = startText
        plan.finishTime = finishText
        
        try! realm.write({
            realm.add(plan) // レコードを追加
        })
        print(plan)

    }
    
    // Realmからデータを取得してテーブルビューを再リロードするメソッド
    func getPlanData() {
        plans = Array(realm.objects(Plan.self)).reversed()  // Realm DBから保存されてる予定を全取得
        tableView.reloadData() // テーブルビューをリロード
    }
    // 初日から最終日までの期間を計算させる
    //その期間をDayPickerに表示させる

}

extension EditViewController: UITableViewDelegate, UITableViewDataSource{
    // TableViewが何個のCellを表示するのか設定するデリゲートメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let planData = realm.objects(Plan.self)
        return planData.count
    }
    // Cellの中身を設定するデリゲートメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let planData = realm.objects(Plan.self)
        //cell.textLabel!.text = "\(planData[indexPath.row].name)さん"
        //ユーザーラベルオブジェクトを作る
        let DetailLabel = cell.viewWithTag(3) as! UILabel
        let StartLabel = cell.viewWithTag(1) as! UILabel
        let FinishLabel = cell.viewWithTag(2) as! UILabel
        //ユーザーラベルに表示する文字列を設定
        DetailLabel.text = "\(planData[indexPath.row].planText)"
        StartLabel.text = "\(planData[indexPath.row].startTime)"
        FinishLabel.text = "\(planData[indexPath.row].finishTime)"
        
        //cell.textLabel!.text = String("\(planData[indexPath.row].planText)")
        return cell
    }
}
