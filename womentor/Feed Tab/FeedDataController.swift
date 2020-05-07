//
//  FeedDataController.swift
//  womentor
//
//  Created by Cooper Jones on 3/23/20.
//  Copyright © 2020 Cooper Jones. All rights reserved.
//

import Foundation

enum DataError:Error{
    case NoPosts
    case NoConvos
    case NoUsers
    case FileDoesNotExist
    case DecodingError
    case AddPostFailure
    case DataWriteFailure
}

struct Post:Codable{
    var timestamp: Date?
    
    var userFullName: String
    var userUsername: String
    var userColor: String
    
    var postContent: String
}

struct FeedDataModel:Codable{
    var posts: [Post]
}


class FeedDataController{
    var posts: [String:Post]?
    
    let fileName = "posts"
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
        
        
        print("Loading Posts...")
        
        if let dataURL = pathURL{
            let decoder = PropertyListDecoder()
            do{
                let data = try Data(contentsOf: dataURL)
                posts = try decoder.decode([String:Post].self, from: data)
                print("Posts Loaded")
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
        print("Writing Data")
        let url = getDataFile(datafile: fileName + fileExtension)
        
        let encoder = PropertyListEncoder()
        
        encoder.outputFormat = .xml
        
        do{
            print(posts)
            let data = try encoder.encode(posts.self)
            print(data)
            try data.write(to: url)
            print("Data Saved to \(url)")
        } catch{
            print(error)
            throw DataError.DataWriteFailure
        }
    }
    
    func getPosts(messageIds: [String]) throws -> [Post]{
        
        guard let postDict = posts else{
            throw DataError.NoPosts
        }
        var postList = [Post]()
        
        for id in messageIds{
            if let post = postDict[id]{
                postList.append(post)
            }
        }
        
        return postList.sorted {$0.timestamp! > $1.timestamp!}
    }
    
    func addPost(newPost: Post, newPostId: String) throws{
        guard posts != nil else{
            throw DataError.AddPostFailure
        }
        
        posts?[newPostId] = newPost
    }
    
    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    func getUniqueKey() throws -> String{
        let newKey = randomString(length: 10)
        if let keys = posts?.keys{
            for key in keys{
                if key == newKey{
                    return try getUniqueKey()
                }
            }
            return newKey
        } else {
            throw DataError.NoPosts
        }
    }

    
}
