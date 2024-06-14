//
//  Record.swift
//  NomaDo
//
//  Created by Seo-Jooyoung on 6/15/24.
//

import Foundation
import SwiftData
 
@Model
class Record {
    @Attribute(.unique) var id = UUID()
    var date: Date
    var togetherPeople: [Int]
    
    init(date:Date, togetherPeople: [Int]) {
        self.date = date
        self.togetherPeople = togetherPeople
    }
}
