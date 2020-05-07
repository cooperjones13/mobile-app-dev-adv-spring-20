//
//  InboxDataController.swift
//  womentor
//
//  Created by Cooper Jones on 3/25/20.
//  Copyright © 2020 Cooper Jones. All rights reserved.
//

import Foundation

struct Message:Codable{
    var sender: String?
    var recipient: String?
    var content: String?
    var timestamp: Date?
}

struct Conversation: Codable {
    var users: [String]? //will become User Id
    var messages: [Message]?
}

struct ConvoStub{
//    var recipientUID:String? //will be implemeted later
    var convoId: String?
    var recipientName: String?
    var latestMessage: String?
    var timestamp: Date?
}

class InboxDataController{
    var conversations: [String:Conversation]?
    
    let fileName = "conversations"
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
        
        
        print("Loading Convos...")
        
        if let dataURL = pathURL{
            let decoder = PropertyListDecoder()
            do{
                let data = try Data(contentsOf: dataURL)
                conversations = try decoder.decode([String:Conversation].self, from: data)
                print("Convos Loaded")
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
        print("Writing Convo Data")
        let url = getDataFile(datafile: fileName + fileExtension)
        
        let encoder = PropertyListEncoder()
        
        encoder.outputFormat = .xml
        
        do{
//            print(posts)
            let data = try encoder.encode(conversations.self)
            print(data)
            try data.write(to: url)
            print("Convos Saved to \(fileName + fileExtension)")
        } catch{
            print(error)
            throw DataError.DataWriteFailure
        }
    }

    func getConvos(_ convoIds:[String]) throws -> [String:Conversation]?{
        var results:[String:Conversation] = [:]
        if let convos = conversations{
            for convoId in convoIds{
                for convo in convos{
                    if convo.key == convoId{
                        results[convo.key] = convo.value
                    }
                }
            }
            return results
        }
        else{
            throw DataError.NoConvos
        }
    }
    
    func getConvoById(id: String) throws -> Conversation?{
        if let convos = conversations{
            return convos[id]
        }else{
            throw DataError.NoConvos
        }
    }
//    
    func getConvoStubData(convoIds:[String], currentUser:User) throws -> [ConvoStub]{
        var convoStubs = [ConvoStub]()
        
        if let convos = try getConvos(convoIds){
            for convo in convos{
//                print(convoId)
                if let users = convo.value.users{
                    for user in users{
//                        print("\(user) : \(currentUser.userName)")
                        if user != currentUser.userName{
                            let recipient = user;
//                            try convoStubs.append(ConvoStub(recipientName: recipient, latestMessage: getLatestMessageContent(id: convo.key)))
                            
                            var stub = ConvoStub(convoId:convo.key, recipientName: recipient)
                            if let latestMessage = try getLatestMessageContent(id: convo.key){
                                stub.latestMessage = latestMessage["message"] as? String
                                stub.timestamp = latestMessage["timestamp"] as? Date
                            }
                            
                            convoStubs.append(stub)
                        }
                    }
                }
            }
            
        }
        else{
            throw DataError.NoConvos
        }
        return convoStubs.sorted{$0.timestamp! > $1.timestamp!}
    }
    
    func getLatestMessageContent(id:String) throws -> [String:Any]?{
        if let convos = conversations{
            if let convo = convos[id]{
                guard var msgs = convo.messages else{
                    return ["error":"Messages dont exist?"]
                }
                msgs.sort {$0.timestamp! > $1.timestamp!}
                guard msgs.count > 0 else{
                    return ["error":"No messages"]
                }
                return ["message": msgs.first?.content ?? "Message Content Not Found", "id": id, "timestamp":msgs.first?.timestamp ?? Date(timeIntervalSince1970: 0)]
            }else{
                return ["error":"Convo \(id): not found"]
            }
        } else{
            throw DataError.NoConvos
        }
    }
    
    func addMessage(conversationId: String, msg: Message){
        guard conversations != nil else{
            return
        }
        conversations![conversationId]?.messages?.append(msg)
        do {
            try writeData()
        } catch{
            print("Error Saving Message")
        }
    }
}
