//
//  SportTeams.swift
//  lab-01-tabs-and-pickers
//
//  Created by Cooper Jones on 2/5/20.
//  Copyright © 2020 Cooper Jones. All rights reserved.
//

import Foundation

struct SportTeams:Decodable{
	let sport:String
	let teams:[String]
}
