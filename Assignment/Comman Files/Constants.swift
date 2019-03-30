//
//  HttpUrlPath.swift
//  Biller1
//
//  Created by Harshit Maheshwari on 19/02/19.
//  Copyright © 2019 Harshit Maheshwari. All rights reserved.
//

import Foundation
import UIKit

// constant values
class Constants{
    
  static var base_url = "https://api.github.com/users/JakeWharton/repos?"
  static let appColor = UIColor(red: 101.0/255.0, green: 125.0/255.0, blue: 137.0/255.0, alpha: 1)
    
}

// hTTPS methods type
enum HttpsMethod{
    case Post
    case Get
    case Put
    
    var localization:String{
        switch self {
        case .Post: return "POST"
        case .Get: return "GET"
        case .Put: return "PUT"
        
        }
        
    }
}
