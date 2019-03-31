//
//  URLRequest.swift
//  Assignment
//
//  Created by Mahendra Vishwakarma on 31/03/19.
//  Copyright © 2019 Mahendra Vishwakarma. All rights reserved.
//

import Foundation

public class HeaderRequest{
    
    class func requestWithHeaders(httpMethod: HttpsMethod, url: String) -> URLRequest? {
        
        guard let validURL = URL(string: url) else{
            return nil
        }
        var request = URLRequest(url: validURL)
        request.httpMethod = httpMethod.localization
        request.timeoutInterval = 60
        var headers = request.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        request.allHTTPHeaderFields = headers
        
        return request
    }
}
