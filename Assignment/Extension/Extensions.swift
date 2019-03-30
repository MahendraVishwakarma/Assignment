//
/*
  * this class is used for implementation of UserList class.
  * tableView dataSource & delegate method is defined
  * reloads data on cells
 
 */
//

import Foundation
import UIKit
import SVProgressHUD

extension UserList{
    
    func getDataFromServer(limit:Int){
        isFetched = false
        
        //self.userListTableView.tableFooterView = UIView(frame: .zero)
        WebServices.requestHttp(pageNumber: limit, method: HttpsMethod.Get, decode: { json -> GitUsers? in
            
            guard let response = json as? GitUsers else{
                return nil
            }
            
            return response
            
        }) { (response:Result) in
            DispatchQueue.main.async {
               self.isFetched = true
                switch response{
                case .success(let data) :
                    DispatchQueue.main.async {
                        
                        SVProgressHUD.dismiss()
                        guard let userData = data else{
                            return
                        }
                        self.activityIndicator.stopAnimating()
                        self.GitUsers.addObjects(from: userData)
                        self.userListTableView.reloadData()
                        if(userData.count > 0){
                            self.previousPageNumber = self.currentPageNumber
                        }else{
                            self.showToast(message: "​there​ ​is​ ​no​ ​more​ ​items​ ​available")
                        }
                        
                       
                    }
                    
                    
                    break
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    self.activityIndicator.stopAnimating()
                    self.showToast(message: error.localizedDescription)
                    SVProgressHUD.dismiss()
                    break
                    
                }
                
                
            }
        }
    }
}
   
// Userlist tableview delegate
extension UserList:UITableViewDelegate{
    
    //calls when tapped on cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}


// Userlist tableview datasource
extension UserList:UITableViewDataSource{
    
    //returns number of items in listing
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.GitUsers.count
    }
    
    // provides data to each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard  let userCell = tableView.dequeueReusableCell(withIdentifier: "userlist", for: indexPath) as? UserListCell  else{
            return UITableViewCell()
        }
        
        
        let  user = self.GitUsers[indexPath.row] as! UserInfo
        
        self.userName.text = user.owner.login
        userCell.name.text = user.name
        userCell.comments.text = user.description
        if(user.owner.avatarURL.count > 0){
            
           userCell.userImage.loadImageUsingCacheWithURLString(user.owner.avatarURL, placeHolder: nil)
            
        }
        
        if((user.language?.count ?? 0) > 0){
             userCell.lblTech.text = user.language
             userCell.viewTech.isHidden = false
        }else{
            userCell.lblTech.text = ""
            userCell.viewTech.isHidden = true
        }
        
         userCell.lblBugs.text = "\(user.openIssuesCount)"
         userCell.lblViews.text = "\(user.watchersCount)"
       
        
        return userCell
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if(indexPath.row == self.GitUsers.count-1){
            print(indexPath.row)
           
            print("yes mahendra")
            if(self.isFetched && self.currentPageNumber == self.previousPageNumber){
                self.activityIndicator.startAnimating()
                self.currentPageNumber = currentPageNumber + 1
                self.getDataFromServer(limit:self.currentPageNumber )
            }
        }
    }
    
}


extension UIViewController
{
    //toast for message alert.
    func showToast(message : String)
    {
        DispatchQueue.main.async {
            let toastLabel = UILabel(frame: CGRect(x: 50, y: UIScreen.main.bounds.height-100, width:UIScreen.main.bounds.width - 100, height: 40))
            toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            toastLabel.textColor = UIColor.white
            toastLabel.textAlignment = .center;
            toastLabel.font = UIFont(name: "Muli-Regular", size: 12.0)
            toastLabel.text = message
            toastLabel.alpha = 1.0
            toastLabel.layer.cornerRadius = 10;
            toastLabel.clipsToBounds  =  true
            self.view.window?.addSubview(toastLabel)
            UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }, completion: {(isCompleted) in
                toastLabel.removeFromSuperview()
            })
        }
        
        
    }
    
}

let imageCache = NSCache<NSString, UIImage>()
extension UIImageView {
    func loadImageUsingCacheWithURLString(_ URLString: String, placeHolder: UIImage?) {
        self.image = nil
        if let cachedImage = imageCache.object(forKey: NSString(string: URLString)) {
            self.image = cachedImage
            return
        }
        if let url = URL(string: URLString) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                //print("RESPONSE FROM API: \(response)")
                if error != nil {
                    print("ERROR LOADING IMAGES FROM URL: \(String(describing: error))")
                    DispatchQueue.main.async {
                        self.image = placeHolder
                    }
                    return
                }
                DispatchQueue.main.async {
                    if let data = data {
                        if let downloadedImage = UIImage(data: data) {
                            imageCache.setObject(downloadedImage, forKey: NSString(string: URLString))
                            self.image = downloadedImage
                        }
                    }
                }
            }).resume()
        }
    }
}
