//
//  FeedViewController.swift
//  womentor
//
//  Created by Cooper Jones on 3/23/20.
//  Copyright © 2020 Cooper Jones. All rights reserved.
//

import UIKit


class FeedPostCell: UITableViewCell{
    
    @IBOutlet weak var userIcon: UIImageView!
    
    @IBOutlet weak var userFirstLastName: UILabel!
    
    @IBOutlet weak var userUsername: UILabel!
    
    
    @IBOutlet weak var userPostMessage: UILabel!
}

class FeedViewController: UITableViewController {
    
    var userDataController = UserDataController()
    var currentUser:User?
    
    var feedDataController = FeedDataController()
    
    var posts = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()
        do{
            try userDataController.loadData()
            currentUser = userDataController.getCurrentUser()
//            print(currentUser?.username)
            
            try feedDataController.loadData()
            if let currUser = currentUser{
                var messageIds = userDataController.getContactsPostIDs(user:currUser)
                for messageId in userDataController.getUserPostIDs(user: currUser){
                    messageIds.append(messageId)
                }
                posts = try feedDataController.getPosts(messageIds:messageIds)
            }
//            print(currentUser?.isLoggedIn)
        }
        catch{
            print("Could Not Load Data")
        }
        
        let app = UIApplication.shared
        
        NotificationCenter.default.addObserver(self, selector:#selector(FeedViewController.applicationWillResignActive(_: )), name: UIApplication.willResignActiveNotification, object: app)
        
        
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedPostCell", for: indexPath) as! FeedPostCell
        
        cell.userFirstLastName?.text = posts[indexPath.row].userFullName
        cell.userUsername?.text = "@" + posts[indexPath.row].userUsername
        cell.userPostMessage?.text = posts[indexPath.row].postContent
        
        cell.userIcon?.tintColor = getColor(name: posts[indexPath.row].userColor)
        
        return cell
    }
    
    func getColor(name: String) -> UIColor{
        switch name.lowercased() {
            case "pink": return UIColor.systemPink
            case "purple": return UIColor.systemPurple
            case "orange": return UIColor.systemOrange
            case "yellow" : return UIColor.systemYellow
            case "green": return UIColor.systemGreen
            case "red" : return UIColor.systemRed
            default: return UIColor.systemBlue
        }
    }
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
//        print(segue.identifier)
        
        if segue.identifier == "post"{
            let src = segue.source as! NewPostViewController
            let timestamp = Date()
            if let user = currentUser{
                if  let fullName = user.fullName, let userName = user.userName {
                    
                    if src.postContent?.isEmpty == false{
                        let newPost = Post(timestamp: timestamp, userFullName: fullName, userUsername: userName, userColor: "red", postContent: src.postContent ?? "Post Content Not Found")
                        do{
                            let id = try feedDataController.getUniqueKey()
                            
                            try feedDataController.addPost(newPost: newPost, newPostId: id)
                            try feedDataController.writeData()
                            userDataController.addUserPost(user: user, postId: id)
                            try userDataController.writeData()
                            posts.append(newPost)
                            posts.sort {$0.timestamp! > $1.timestamp!}
                            
                        }catch{
                            print("error")
                        }
                    
                    }
                }else{
                    print(currentUser?.fullName)
                    print(currentUser?.userName)
//                    print(currentUser?.iconColor)
                }
            }
            tableView.reloadData()
        }
    }
    
    @objc func applicationWillResignActive(_ notification: NSNotification){
        do {
            try feedDataController.writeData()
            try userDataController.writeData()
        } catch{
            print(error)
        }
    }
    
    
}
