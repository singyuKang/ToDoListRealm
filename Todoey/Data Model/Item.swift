//
//  Item.swift
//  Todoey
//
//  Created by 강신규 on 2023/08/01.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    var parentCategory = LinkingObjects(fromType : Category.self, property  : "items")
    
    
}
