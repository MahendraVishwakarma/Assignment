//
//  UserListCell.swift
//  Assignment
//
//  Created by Mahendra Vishwakarma on 30/03/19.
//  Copyright © 2019 Mahendra Vishwakarma. All rights reserved.
//

import Foundation
import UIKit

// custom cell 
class UserListCell: UITableViewCell {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var comments: UILabel!
    @IBOutlet weak var viewTech: UIView!
    @IBOutlet weak var viewBug: UIView!
    @IBOutlet weak var viewViiews: UIView!
    @IBOutlet weak var lblTech: UILabel!
    @IBOutlet weak var lblViews: UILabel!
    @IBOutlet weak var lblBugs: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        userImage.layer.cornerRadius = 10
        userImage.layer.masksToBounds = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}
