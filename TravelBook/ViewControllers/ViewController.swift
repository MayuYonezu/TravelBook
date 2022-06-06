//
//  ViewController.swift
//  TravelBook
//
//  Created by Mayu Yonezu on 2022/05/22.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    //ピンク
    let pink = UIColor(red: 242/255.0, green: 167/255.0, blue: 167/255.0, alpha: 1.0) // ボタン背景色設定
    
    // 新規プロジェクト作成Btn
    @IBOutlet var NewProjectBtn: UIButton!
    let realm = try! Realm()
    var plans = [Plan]()
    var project = [Project]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //NavigationBarデザイン
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = pink
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "MissionTravel"
        
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //新規ボタンのデザイン
        // 背景色
        NewProjectBtn.backgroundColor = UIColor.white
        // 枠線の幅
        NewProjectBtn.layer.borderWidth = 3
        // 枠線の色
        NewProjectBtn.layer.borderColor = pink.cgColor
        // 角丸のサイズ
        NewProjectBtn.layer.cornerRadius = 10
        //NewProjectBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
    }


}

