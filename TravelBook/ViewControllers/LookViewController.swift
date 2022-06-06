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
    var projects: Project? = nil
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
        self.tableView.reloadData()
    
        tableView.delegate = self
        tableView.dataSource = self
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
        print(projects)
        print(plans)
        let projectData = realm.objects(Project.self).last
        print("🟥全てのデータ\(projectData)")

        openLook()

        
        // Do any additional setup after loading the view.
    }
    
    func openLook(){
        let projectData = realm.objects(Project.self).last
       // print(projectData[0])
        
        missionLabel.text = "\(projectData!.mission)"
        startLabel.text = "\(projectData!.startDays)"
        finishLabel.text = "\(projectData!.finishDays)"
        
    }
    
    @IBAction func Done(){
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func getProjectData() {
        projects = realm.objects(Project.self).last // Realm DBから保存されてるプランを全取得
        plans = Array(projects!.plans)
        tableView.reloadData()
    }
}

extension LookViewController: UITableViewDelegate, UITableViewDataSource{
    // TableViewが何個のCellを表示するのか設定するデリゲートメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // let planData = realm.objects(Plan.self)
        return plans.count
    }
    // Cellの中身を設定するデリゲートメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        // let planData = realm.objects(Plan.self)
        //cell.textLabel!.text = "\(planData[indexPath.row].name)さん"
        //ユーザーラベルオブジェクトを作る
        let DetailLabel = cell.viewWithTag(3) as! UILabel
        let StartLabel = cell.viewWithTag(1) as! UILabel
        let FinishLabel = cell.viewWithTag(2) as! UILabel
        //ユーザーラベルに表示する文字列を設定
        DetailLabel.text = "\(plans[indexPath.row].planText)"
        StartLabel.text = "\(plans[indexPath.row].startTime)"
        FinishLabel.text = "\(plans[indexPath.row].finishTime)"
        
        //cell.textLabel!.text = String("\(planData[indexPath.row].planText)")
        return cell
    }
}
