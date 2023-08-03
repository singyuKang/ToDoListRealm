//
//  Category.swift
//  Todoey
//
//  Created by 강신규 on 2023/08/01.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name : String = ""
    @objc dynamic var backgroundColorHexValue : String = ""
    
//    let items : Array<Item> = []
    let items  =  List<Item>()
    
}

