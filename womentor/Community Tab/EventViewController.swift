//
//  CommunityPageViewController.swift
//  womentor
//
//  Created by Cooper Jones on 3/24/20.
//  Copyright © 2020 Cooper Jones. All rights reserved.
//

import UIKit

class EventViewController: UIViewController{

    @IBOutlet weak var background: UIImageView!
    
    //Buttons
    @IBOutlet weak var infoButton: UIButton!
    
    @IBOutlet weak var shareButton: UIButton!
    
    //Labels
    @IBOutlet weak var eventNameLabel: UILabel!

    @IBOutlet weak var dateTimeLabel: UILabel!

    @IBOutlet weak var locationLabel: UILabel!
    
    var eventName: String?
    var dateTime: Date?
    var location: String?
    var infoLinkURL: String?
    var bgImageName: String?
    
    
    var index: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        dateFormatter.locale = Locale(identifier: "en_US")
        if let date = dateTime{
            dateTimeLabel?.text = dateFormatter.string(from: date)
        }
        
        locationLabel?.text = location

        eventNameLabel?.text = eventName
        
        
        let gradient = CAGradientLayer()
        gradient.frame = background.bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor.systemPurple.withAlphaComponent(0.6).cgColor]
        background.layer.addSublayer(gradient)
        
        let gradientTop = CAGradientLayer()
        gradientTop.frame = background.bounds
        gradientTop.colors = [UIColor.systemPurple.withAlphaComponent(0.5).cgColor, UIColor.clear.cgColor]
        gradientTop.locations = [0, 0.2]
        
        background.layer.addSublayer(gradientTop)
        
        infoButton.layer.shadowColor = UIColor.systemPurple.cgColor
        infoButton.layer.shadowOffset = CGSize(width: 2.0, height: 3.0)
        infoButton.layer.masksToBounds = false
        infoButton.layer.shadowRadius = 3.0
        infoButton.layer.shadowOpacity = 0.5
        
        shareButton.layer.shadowColor = UIColor.systemPurple.cgColor
        shareButton.layer.shadowOffset = CGSize(width: 2.0, height: 3.0)
        shareButton.layer.masksToBounds = false
        shareButton.layer.shadowRadius = 3.0
        shareButton.layer.shadowOpacity = 0.5
        
        if let name = bgImageName{
            background.image = UIImage(named:name)
        }

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func openInfoLink(_ sender: Any) {
        if let link = infoLinkURL{
            guard let url = URL(string: link) else { return }
            UIApplication.shared.open(url)
        }
    }
    
}
