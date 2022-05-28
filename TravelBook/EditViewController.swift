//
//  EditViewController.swift
//  TravelBook
//
//  Created by Mayu Yonezu on 2022/05/22.
//

import UIKit

class EditViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // CVで企画選択時のボタンの背景画像
    @IBOutlet var titeImage: UIImageView!
    // 行く日程
    @IBOutlet weak var StartDayPicker: UIDatePicker!
    // 帰る日程
    @IBOutlet weak var FinishDayPicker: UIDatePicker!
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
    @IBOutlet var addBtn: UIButton!
    
    // ミッションが入ったArray
    let missionArray = ["映えな写真を撮る","おしゃれなVlogを撮る","ストーリーを1日10個載せる","YouTuber風な動画を撮って編集","面白写真を撮る"]
    // pickerViewの要素（仮で1~7日までにする->もし可能であれば必要な日程数のみにする）
    let DaysArray = ["1","2","3","4","5","6","7"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appearance = UINavigationBarAppearance()
        
        // NavigationBar装飾
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 242/255.0, green: 167/255.0, blue: 167/255.0, alpha: 1.0)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.lightText]
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
        
        // 一番初めに表示されるmission
        mission_random()
        
        // Delegate設定
        pickerView.delegate = self
        pickerView.dataSource = self

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
    
    
    
    // 初日から最終日までの期間を計算させる
    //その期間をDayPickerに表示させる

}
