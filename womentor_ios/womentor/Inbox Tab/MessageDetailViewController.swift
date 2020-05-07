//
//  MessageDetailViewControllwe.swift
//  womentor
//
//  Created by Cooper Jones on 5/6/20.
//  Copyright © 2020 Cooper Jones. All rights reserved.
//

import UIKit

protocol CustomCellUpdater: class { // the name of the protocol you can put any
    func updateTableView()
}

class MessageCell:UITableViewCell{
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var msgContent: UILabel!
    @IBOutlet weak var container: UIStackView!
    
    weak var delegate: CustomCellUpdater?

    func updateCells() {
        
        delegate?.updateTableView()
    }
}

class MessageDetailViewController: UITableViewController,CustomCellUpdater {
    var currentUser = User()
    var userDataController = UserDataController()
    var inboxDataController = InboxDataController()
    var conversationId = ""
    var messages = [Message]()
    var conversation:Conversation?
    
    var textView: UITextView = UITextView(frame: CGRect())
    var submitBtn: UIButton  = UIButton(type: UIButton.ButtonType.roundedRect)
    
    
    override func viewWillAppear(_ animated: Bool) {
        do{
            try messages = (inboxDataController.getConvoById(id: conversationId)?.messages?.sorted {$0.timestamp! > $1.timestamp!})!
        }catch{
            print(error)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do{
            conversation = try inboxDataController.getConvoById(id: conversationId)
            if let convo = conversation{
                self.title = try userDataController.getUserById(id: (convo.users?.first {$0 != currentUser.userName})!)?.fullName
            }
        } catch{
            print(error)
        }
        
        tableView.transform = CGAffineTransform(rotationAngle: .pi);
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
//        if let tabBar = self.tabBarController?.tabBar{
//            let view = UIView(frame: tabBar.bounds)
//            self.view.addSubview(view)
//            NSLayoutConstraint.activate([
//                tableView.
//            ])
//
//        }
    
        

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
        return messages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "msgCell", for: indexPath) as! MessageCell
        cell.delegate = self
        
        let msg = messages[indexPath.row]
        cell.transform = CGAffineTransform(rotationAngle: -1 * .pi);
        
        cell.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        NSLayoutConstraint.deactivate(cell.container.constraintsAffectingLayout(for: NSLayoutConstraint.Axis.horizontal))
        NSLayoutConstraint.deactivate(cell.contentView.constraintsAffectingLayout(for: NSLayoutConstraint.Axis.horizontal))
        
        if msg.recipient == currentUser.userName{
        
            cell.layoutIfNeeded()
            NSLayoutConstraint.activate([
                cell.container.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -64),
                cell.container.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16)
            ])
            cell.layoutIfNeeded()
            cell.container.addBackgroundWithRadius(color: UIColor.systemPurple.withSaturation(0.8), cornerRadius: 8)
            cell.nameLabel.textColor = UIColor.white
            cell.msgContent.textColor = UIColor.white
            cell.timestamp.textColor = UIColor.white
                
        } else {
        
            cell.layoutIfNeeded()
            NSLayoutConstraint.activate([
                cell.container.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
                cell.container.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 64)
            ])
            cell.layoutIfNeeded()
            cell.container.addBackgroundWithRadius(color: UIColor.systemPurple.withSaturation(0.1), cornerRadius: 8)
            cell.nameLabel.textColor = UIColor.black
            cell.msgContent.textColor = UIColor.black
            cell.timestamp.textColor = UIColor.black
        }
        
        do{
            cell.nameLabel?.text = try userDataController.getUserById(id: msg.sender!)?.fullName
        }catch{
            print(error)
        }
        cell.msgContent?.text = msg.content

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "en_US")
    
        cell.timestamp?.text = dateFormatter.string(from:msg.timestamp ?? Date(timeIntervalSince1970: 0))
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Sup"
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var inputView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 48))
        
        
        textView.clipsToBounds = true
        textView.layer.cornerRadius = 8
        
        submitBtn.scalesLargeContentImage = true
        submitBtn.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        submitBtn.tintColor = UIColor.white
        submitBtn.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        
        
        var stackView = UIStackView(frame:CGRect(x: 16, y: 8, width: tableView.bounds.width-32, height: 32))
        stackView.addArrangedSubview(textView)
        stackView.addArrangedSubview(submitBtn)
        
        stackView.spacing = 16
        inputView.addSubview(stackView)
    
//        NSLayoutConstraint.deactivate([
//            textView
//        ])
//        print(stackView.constraints)
        
        inputView.backgroundColor = UIColor.systemPurple.withSaturation(0.5)
        
        inputView.transform = CGAffineTransform(rotationAngle: -1 * .pi);
        return inputView
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            let tabBarHeight = (tabBarController?.tabBar.frame.height)!
//            print(tabBarHeight)
//            print(keyboardSize.height)
            
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height - tabBarHeight
            }
            
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if tableView.frame.origin.y != 0 {
            tableView.frame.origin.y = 0
        }
    }

    @objc func sendMessage(){
        guard !textView.text.isEmpty else{
            return
        }
        if let convo = conversation{
            let recipient = convo.users?.first {$0 != currentUser.userName}
            let content = textView.text
            let msg = Message(sender: currentUser.userName, recipient: recipient, content: content, timestamp: Date())
            messages.append(msg)

            inboxDataController.addMessage(conversationId:conversationId, msg: msg)
        }
        
        messages.sort {$0.timestamp! > $1.timestamp!}
        
        tableView.layoutIfNeeded()
        tableView.reloadData()
    }
    
    func updateTableView() {
        tableView.reloadData()
    }
    
}
