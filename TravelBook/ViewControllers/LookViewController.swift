//
//  LookViewController.swift
//  TravelBook
//
//  Created by Mayu Yonezu on 2022/05/22.
//

import UIKit
import RealmSwift

class LookViewController: UIViewController {
    
    let realm = try! Realm()
    var projects = [Project]()
    var plans = [Plan]()
    
    // ミッション表示
    @IBOutlet var missionLabel: UILabel!
    // 始まる日にちを表示
    @IBOutlet var startLabel: UILabel!
    // 終わる日にちを表示
    @IBOutlet var finishLabel: UILabel!
    //スケジュールを表示させるためのTebleView
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 242/255.0, green: 167/255.0, blue: 167/255.0, alpha: 1.0)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.lightText]
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
        
        print("LookViewControllerへ画面遷移しました")
        getProjectData()
        getPlanData()
        print(projects[1])
        print(plans)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func Done(){
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func getProjectData() {
        projects = Array(realm.objects(Project.self)).reversed()  // Realm DBから保存されてるプランを全取得
    }
    
    func getPlanData() {
        plans = Array(realm.objects(Plan.self)).reversed()
    }
    
}
