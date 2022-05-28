//
//  EditViewController.swift
//  TravelBook
//
//  Created by Mayu Yonezu on 2022/05/22.
//

import UIKit
import RealmSwift

class EditViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //パーツ宣言---------------------------------------------
    // CVで企画選択時のボタンの背景画像
    @IBOutlet var titeImage: UIImageView!
    // 行く日程
    @IBOutlet weak var StartDayPicker: UIDatePicker!
    // 帰る日程
    @IBOutlet weak var FinishDayPicker: UIDatePicker!
    //スケジュールを表示させるためのTebleView
    @IBOutlet var tableView: UITableView!
    // 企画のタイトルを入れるためのTextField
    @IBOutlet var titleName: UITextField!
    // ミッションを表示させるためのLabel
    @IBOutlet var missionLabel: UILabel!
    // ミッションを違うものに変更するためのButton
    @IBOutlet var missionUpdateBtn: UIButton!
    //Section選択するためのPicker
    @IBOutlet weak var pickerView: UIPickerView!
    // 予定の詳細を書くためTextField
    @IBOutlet var detailTextFiled: UITextField!
    // 予定の始まる時間
    @IBOutlet weak var StartTimePicker: UIDatePicker!
    // 予定の終わりの時間
    @IBOutlet weak var FinishTimePicker: UIDatePicker!
    // 予定を追加するためのButton
    //@IBOutlet var addBtn: UIButton!
    
    //ミッション-------------------------------------------
    // ミッションが入ったArray
    let missionArray = ["映えな写真を撮る","おしゃれなVlogを撮る","ストーリーを1日10個載せる","YouTuber風な動画を撮って編集","面白写真を撮る"]
    // pickerViewの要素（仮で1~7日までにする->もし可能であれば必要な日程数のみにする）
    let DaysArray = ["1","2","3","4","5","6","7"]
    
    //Realm-----------------------------------------------
    let realm = try! Realm()
    var plans = [Plan]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Navigation装飾
        navigation()
        // 一番初めに表示されるmission
        mission_random()
        
        // Delegate設定
        pickerView.delegate = self
        pickerView.dataSource = self
        
        // TableViewの初期設定
        tableView.delegate = self
        tableView.dataSource = self

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
    
    // DayPickerの列の数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // UIPickerViewの行数、リストの数
    func pickerView(_ pickerView: UIPickerView,numberOfRowsInComponent component: Int) -> Int {
        return DaysArray.count
    }
    
    // UIPickerViewの最初の表示
    func pickerView(_ pickerView: UIPickerView,titleForRow row: Int,forComponent component: Int) -> String? {
            return DaysArray[row]
        }
    
    // UIPickerViewのRowが選択された時の挙動
    func pickerView(_ pickerView: UIPickerView,didSelectRow row: Int,inComponent component: Int) {
            //label.text = dataList[row]
        }
    
    // "予定を追加"をタップされたとき
    @IBAction func addBtn(){
        guard let _ = detailTextFiled.text else {return}
        
        savePlan()
        
        // detailTextFieldを初期化する
        detailTextFiled.text = ""
        print("保存")
    }
    
    // 予定を保存
    func savePlan(){
        guard let planText = detailTextFiled.text else { return }
        
        let plan = Plan()
        plan.planText = planText
        
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
        plans.count
    }
    // Cellの中身を設定するデリゲートメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlanCell", for: indexPath)
        guard let planLabel = cell.viewWithTag(8) as? UILabel else { return cell }
              //let planImageView = cell.viewWithTag(4) as? UIImageView else { return cell }
        
        let plan = plans[indexPath.row]
        planLabel.text = plan.planText
        
        return cell
    }
}
