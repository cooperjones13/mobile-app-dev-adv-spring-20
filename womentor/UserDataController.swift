//
//  UserDataController.swift
//  womentor
//
//  Created by Cooper Jones on 3/26/20.
//  Copyright © 2020 Cooper Jones. All rights reserved.
//

import Foundation
import UIKit

class User:Codable{
    var isLoggedIn:Bool?
    
    var fullName:String?
    var userName:String?
    
    var contactIDs:[String]?
    
    var postIDs:[String]?
    
    var conversationIDs:[String]?
    
    var iconColor:String?
    
}

class UserDataController{
    var users:[String:User]?
    
    let fileName = "users"
    let fileExtension = ".plist"
    
    func getDataFile(datafile: String) -> URL {
        //get path
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let directory = path[0]
        
        //return url
        return directory.appendingPathComponent(datafile)
    }
    
    func loadData() throws{
        let pathURL: URL?
        
        let url = getDataFile(datafile: fileName + fileExtension)
        
        if FileManager.default.fileExists(atPath: url.path){
            pathURL = url
        } else{
            pathURL = Bundle.main.url(forResource: fileName, withExtension: fileExtension)
        }
        
        
        print("Loading Users...")
        
        if let dataURL = pathURL{
            let decoder = PropertyListDecoder()
            do{
                let data = try Data(contentsOf: dataURL)
                users = try decoder.decode([String:User].self, from: data)
                print("Users Loaded")
//                print(users)
            }catch{
                print(error)
                print("Could Not Decode")
                throw DataError.DecodingError
            }
        }
        else{
            print("No File Found")
            throw DataError.FileDoesNotExist
        }
    }
    
    func writeData() throws{
        let url = getDataFile(datafile: fileName + fileExtension)
        
        let encoder = PropertyListEncoder()
        
        encoder.outputFormat = .xml
        
        do{
            let data = try encoder.encode(users.self)
            try data.write(to: url)
            print("Data Saved to \(fileName + fileExtension)")
        } catch{
            print(error)
            throw DataError.DataWriteFailure
        }
    }
    
    func getCurrentUser() -> User?{
        guard let userDict = users else{
            return nil
        }
        var currentUser:User?
        
        for userID in userDict.keys{
            guard let user = userDict[userID] else{
                continue
            }
            guard let userIsCurrent = user.isLoggedIn else{
                continue
            }
            
            if userIsCurrent{
                currentUser = user
            }
        }
        
        return currentUser
    }
    
    func getUserPostIDs(user: User) -> [String]{

        if let userPostIDs = user.postIDs{
            return userPostIDs
        }
    
        return []
    }
    
    func getContactsPostIDs(user: User) -> [String]{
        guard let userDict = users else{
            return []
        }
        guard let contactIds = user.contactIDs else{
            return []
        }
        
        var postIds = [String]()
        
        
        for contactId in contactIds{
            if let contactPosts = userDict[contactId]?.postIDs{
                for id in contactPosts{
                    postIds.append(id)
                }
            }
        }
        return postIds
    }
    
    func getUserConversationIDs(user:User) -> [String]{
        var convoIds = [String]()
            
        if let userConvoIDs = user.conversationIDs{
            convoIds = userConvoIDs
        }
    
        return convoIds
    }
    
    func getUserContacts(user:User) -> [User]{
        var contacts = [User]()
        guard let userDict = users else{
            return []
        }

        if let userContactIDs = user.contactIDs{
            for contactId in userContactIDs{
                if let newContact = userDict[contactId]{
                    contacts.append(newContact)
                }
            }
        }
    
        return contacts
    }
    
    func addUserPost(user: User, postId: String){
        user.postIDs?.append(postId)
        print(users?[user.userName!]?.conversationIDs)
        user.iconColor = "blue"
        users?[user.userName!] = user
        print(users?[user.userName!]?.conversationIDs)
    }
    
    func getUserById(id: String) throws -> User?{
        if let allUsers = users{
            return allUsers[id]
        }else{
            throw DataError.NoUsers
        }
    }
}
