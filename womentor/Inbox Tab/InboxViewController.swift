//
//  InboxViewController.swift
//  womentor
//
//  Created by Cooper Jones on 3/24/20.
//  Copyright © 2020 Cooper Jones. All rights reserved.
//

import UIKit

class InboxConvoCell: UITableViewCell{
    
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var latestMessage: UILabel!
    @IBOutlet weak var userFullName: UILabel!
    @IBOutlet weak var userIcon: UIImageView!
}

class InboxViewController: UITableViewController {
    
    var convoStubs = [ConvoStub]()
    
    var userController = UserDataController()
    var currentUser:User?
    
    var data = InboxDataController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        do{
            try data.loadData()
            try userController.loadData()
            currentUser = userController.getCurrentUser()
            if let currUser = currentUser{
                let convoIds = userController.getUserConversationIDs(user: currUser)
//                print(convoIds)
                convoStubs = try data.getConvoStubData(convoIds: convoIds, currentUser: currUser)
            }
            
        } catch{
            print(error)
        }

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
        return convoStubs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "inboxConvoCell", for: indexPath) as! InboxConvoCell
        
        let cellStub = convoStubs[indexPath.row]
        
        cell.userFullName?.text = cellStub.recipientName
        cell.latestMessage?.text = cellStub.latestMessage
        cell.userIcon.tintColor = UIColor.systemPink
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "en_US")
        
        
        cell.timestamp?.text = dateFormatter.string(from:cellStub.timestamp ?? Date(timeIntervalSince1970: 0))
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MessageDetailSegue"{
            let detailVC = segue.destination as! MessageDetailViewController
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell)
            
            if let selection = indexPath?.row{
                let convoStub = convoStubs[selection]
                detailVC.currentUser = currentUser!
                detailVC.conversationId = convoStub.convoId!
                detailVC.title = convoStub.recipientName
                detailVC.inboxDataController = data
                detailVC.userDataController = userController
            }
//            print(detailVC)
        }
    }
    

}
