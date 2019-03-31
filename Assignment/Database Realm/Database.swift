//
//  Database.swift
//  Assignment
//
//  Created by Mahendra Vishwakarma on 31/03/19.
//  Copyright © 2019 Mahendra Vishwakarma. All rights reserved.
//

import Foundation
import RealmSwift

class DBManager {
    //MARK: Singleton
    static let sharedInstance = DBManager()

    var realmObject:Realm!
    //MARK: Init
    private init(){
    
        do{
             realmObject = try Realm()
        }catch let err{
           
            print(err.localizedDescription)
        }
        
    }
    
    func getData() -> NSArray{
        let data =  DBManager.sharedInstance.realmObject.objects(MyRealObject.self)
        let arr = data.toArray(type: MyRealObject.self)
        
        return arr as NSArray
    }

}

class MyRealObject : Object {
    
    @objc dynamic var structData:Data? = nil
    @objc dynamic var id = 0
    override static func primaryKey() -> String? {
        return "id"
    }
    
    var myStruct : UserInfo? {
        get {
            if let data = structData {
                
                return try? JSONDecoder().decode(UserInfo.self, from: data)
            }
            return nil
        }
        set {
            structData = try? JSONEncoder().encode(newValue)
        }
    }
}
