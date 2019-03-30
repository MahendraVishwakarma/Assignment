//
//  UserList.swift
//  Assignment
//
//  Created by Mahendra Vishwakarma on 30/03/19.
//  Copyright © 2019 Mahendra Vishwakarma. All rights reserved.
//


import UIKit
import SVProgressHUD

class UserList: UIViewController {

    var GitUsers = NSMutableArray()
    var lastContentOffset: CGFloat = 0
    var currentPageNumber = 1
    var previousPageNumber = 1
    var isFetched = false
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userListTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        SVProgressHUD.show()
        getDataFromServer(limit: 1)
    }
    

}
