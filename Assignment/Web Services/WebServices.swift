//
//  WebServices.swift
//  Assignment
//
//  Created by Mahendra Vishwakarma on 30/03/19.
//  Copyright © 2019 Mahendra Vishwakarma. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration


public class WebServices{
    
    // checks internet connection.
    class func isConnectedToNetwork() -> Bool
    {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        
        return (isReachable && !needsConnection)
        
    }

    // creates request from fetch data from server.
    
    class func requestHttp<T:Decodable>(pageNumber:Int,method:HttpsMethod, decode:@escaping(Decodable) -> T?, completion: @escaping (Result<T?,APIError>)->()){
        
        let headers = [
            "Content-Type": "application/json",
            "cache-control": "no-cache",
            ]
        
        if(!isConnectedToNetwork())
        {
            openNoConnectionView()
            completion(Result.failure(APIError.failedRequest("no internet connection")))
            return
        }
        
        let url = Constants.base_url + "page=\(pageNumber)&per_page=15"
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL,cachePolicy: .useProtocolCachePolicy,timeoutInterval: 10.0)
        
        request.httpMethod = method.localization
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error as Any)
                completion(Result.failure(APIError.failedRequest(error?.localizedDescription)))
                
            } else {
                
                
                guard let serverData = data,
                    error == nil else {
                        print(error?.localizedDescription ?? "Response Error")
                        return
                }
                
                do{
                    let decoder = JSONDecoder();
                    let object = try decoder.decode(T.self, from: serverData)
                    completion(Result.success(object))
                } catch let parsingError {
                    completion(Result.failure(APIError.failedRequest(parsingError.localizedDescription)))
                    //print("Error", parsingError)
                }
                
                
                
                
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse as Any)
                
                
            }
        })
        
        
        dataTask.resume()
        
    }
    
    class func openNoConnectionView()
    {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let strbrd = UIStoryboard.init(name: "Main", bundle: nil)
        let customReviewPopup = strbrd.instantiateViewController(withIdentifier: "NoInternetConnection") as! NoInternetConnection
        
        let presented_already = appDelegate.window?.viewWithTag(123456)
        
        if(presented_already == nil)
        {
            appDelegate.window?.rootViewController?.present(customReviewPopup, animated: true, completion: nil)
            
        }
        
    }
    
}




