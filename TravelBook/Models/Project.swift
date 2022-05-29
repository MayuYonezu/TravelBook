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
}
