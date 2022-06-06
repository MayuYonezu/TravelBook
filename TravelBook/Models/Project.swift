//
//  Project.swift
//  TravelBook
//
//  Created by Mayu Yonezu on 2022/05/29.
//

import Foundation
import RealmSwift


// データベースの箱
class Project: Object {
    @objc dynamic var startDays: String = ""
    @objc dynamic var finishDays: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var mission: String = ""
    let plans = List<Plan> ()
    override static func primaryKey() -> String? {
            return "startDays"
    }
}

class Plan: Object {
    @objc dynamic var planDay: String = ""
    @objc dynamic var planText: String = ""
    @objc dynamic var startTime: String = ""
    @objc dynamic var finishTime: String = ""
    let parentCategory = LinkingObjects(fromType: Project.self, property: "plans")
//    override static func primaryKey() -> String? {
//            return "planDay"
//    }
}

