//
//  PickerViewController.swift
//  lab-01-tabs-and-pickers
//
//  Created by Cooper Jones on 2/5/20.
//  Copyright © 2020 Cooper Jones. All rights reserved.
//

import UIKit

class PickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
	
	let sportComp = 0
	let teamComp = 1
	
	var sportTeams = SportTeamsDataController()
	var sports = [String]()
	var teams = [String]()
	
	
	@IBOutlet weak var output: UILabel!
	@IBOutlet weak var picker: UIPickerView!
	
	override func viewDidLoad() {
        super.viewDidLoad()
        //LOAD DATA
		do{
			try sportTeams.loadData()
			sports = try sportTeams.getSports()
			teams = try sportTeams.getTeams(i: 0)
			
		}catch{
			print(error)
		}
    }
	
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 2
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		if component == sportComp {
			return sports.count
			
		} else if component == teamComp {
			return teams.count
		} else {
			print("Unknown Component")
			return -1
		}
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		if component == sportComp {
			return sports[row]
			
		} else if component == teamComp {
			return teams[row]
		} else {
			print("Unknown Component")
			return "Unknown Component"
		}
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		if component == sportComp{
			do {
				teams = try sportTeams.getTeams(i: row)
			}catch{
				print(error)
			}
			
			picker.reloadComponent(teamComp)
			picker.selectRow(0, inComponent: teamComp, animated: true)
		}
//		let sport = picker.selectedRow(inComponent: sportComp)
		let team = picker.selectedRow(inComponent: teamComp)
		
		output.text = "\(teams[team])"
	}

}

