//
//  CommunityDataController.swift
//  womentor
//
//  Created by Cooper Jones on 3/24/20.
//  Copyright © 2020 Cooper Jones. All rights reserved.
//

import Foundation

class EventDataModel: Codable{
    var eventName: String?
    var eventDateTime: Date?
    var eventLocation: String?
    var infoLinkURL: String?
    var imageName: String?
}

class CommunityDataController{
    
    var events: [EventDataModel]?
    
    func loadData() throws{
        print("Loading Events Data...")
        if  let pathURL        = Bundle.main.url(forResource: "events", withExtension: "plist")
        {
            
            do{
                let data = try Data(contentsOf: pathURL)
                events = try PropertyListDecoder().decode([EventDataModel].self, from: data)
                print("Events Loaded")
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
    
    func getEvents() throws -> [EventDataModel]{
        if let eventList = events{
            return eventList
        }
        else{
            throw DataError.NoPosts
        }
    }
}
