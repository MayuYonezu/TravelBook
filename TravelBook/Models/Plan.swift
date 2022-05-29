//
//  Plan.swift
//  TravelBook
//
//  Created by Mayu Yonezu on 2022/05/28.
//

import Foundation
import RealmSwift

// データベースの箱
class Plan: Object {
    @objc dynamic var planText: String = ""
    @objc dynamic var startTime: String = ""
    @objc dynamic var finishTime: String = ""
}
