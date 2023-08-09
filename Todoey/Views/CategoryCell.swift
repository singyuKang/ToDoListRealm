//
//  CategoryCell.swift
//  Todoey
//
//  Created by 강신규 on 2023/08/09.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {

    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryImageView: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        categoryCircleView.layer.cornerRadius = 55
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        
        
    }
    
}
