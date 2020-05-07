//
//  ExternalAppViewController.swift
//  lab-01-tabs-and-pickers
//
//  Created by Cooper Jones on 2/5/20.
//  Copyright © 2020 Cooper Jones. All rights reserved.
//

import UIKit

class ExternalAppViewController: UIViewController {

	
	@IBOutlet weak var spotifyBtn: UIButton!
	let spotifyScheme = "spotify://"
	
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
	
	func openApp(scheme: String){
		if let url = URL(string: scheme){
			UIApplication.shared.open(url, options: [:], completionHandler: {
				(success) in
				print("Open \(scheme): \(success)")
			})
		}
	}
	
	func hasApp(scheme: String) -> Bool{
		if let url = URL(string: scheme){
			return UIApplication.shared.canOpenURL(url)
		}
		return false
	}
	
	@IBAction func openSpotify(_ sender: Any) {
		
		let spotifyInstalled = hasApp(scheme: spotifyScheme)
		
		if spotifyInstalled{
			openApp(scheme: spotifyScheme)
		} else{
			openApp(scheme: "http://www.apple.com/music")
			print("You don't have spotify...smh")
		}
	}
	

}
