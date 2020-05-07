//
//  SportTeamDataController.swift
//  lab-01-tabs-and-pickers
//
//  Created by Cooper Jones on 2/5/20.
//  Copyright © 2020 Cooper Jones. All rights reserved.
//

import Foundation

enum DataError:Error{
	case BadFilePath
	case CouldNotDecodeData
	case NoData
}

class SportTeamsDataController{
	var sportTeamsData: [SportTeams]?
	let filename = "teams"
	
	func loadData() throws {
		print("Loading Data from PropertyList...")
		if let pathURL = Bundle.main.url(forResource: filename, withExtension: "plist"){
			let decoder = PropertyListDecoder()
			do{
				let data = try Data(contentsOf: pathURL)
				sportTeamsData = try decoder.decode([SportTeams].self, from: data)
				print("Data Loaded")
			}catch{
				throw DataError.CouldNotDecodeData
			}
		}else{
			throw DataError.BadFilePath
		}
	}
	
	func getSports() throws -> [String]{
		var sports = [String]()
		
		if let data = sportTeamsData{
			for sport in data{
				sports.append(sport.sport)
			}
			return sports
		}else{
			throw DataError.NoData
		}
	}
	
	func getTeams(i:Int) throws -> [String] {
		if let data = sportTeamsData{
			return data[i].teams
		}else{
			throw DataError.NoData
		}
	}
	
}
