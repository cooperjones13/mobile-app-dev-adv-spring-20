//
//  CommunityViewController.swift
//  womentor
//
//  Created by Cooper Jones on 3/24/20.
//  Copyright © 2020 Cooper Jones. All rights reserved.
//

import UIKit

class CommunityViewController: UIViewController {

    @IBOutlet weak var eventView: UIView!
    @IBOutlet weak var noEventsFoundLabel: UILabel!
    
    
    var events = [EventDataModel]()
    var communityDataController = CommunityDataController()
    
    var currViewIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do{
            try communityDataController.loadData()
            events = try communityDataController.getEvents()
        }catch{
            print(error)
            noEventsFoundLabel.isHidden = true
        }
        configurePageViewController()

        // Do any additional setup after loading the view.
    }
    
    func configurePageViewController(){
        
        guard let pageViewController = storyboard?.instantiateViewController(identifier: String(describing: CommunityPageViewController.self)) as? CommunityPageViewController else{
                return
        }
        
        pageViewController.delegate = self
        pageViewController.dataSource = self
        
        addChild(pageViewController)
        
        pageViewController.didMove(toParent: self)
        
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        pageViewController.view.backgroundColor = UIColor.systemPurple
        
        eventView.addSubview(pageViewController.view)
        
        let views: [String: Any] = ["pageView": pageViewController.view as Any]

    eventView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[pageView]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views))
    eventView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[pageView]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views))
        
        
        guard let startingViewController = detailViewController(index: currViewIndex) else {
            return
        }
        
        pageViewController.setViewControllers([startingViewController], direction: .forward, animated: true)
        
    }
    
    func detailViewController(index: Int) -> EventViewController?{
        
        if index >= events.count || events.count == 0{
            return nil
        }
        
        guard let eventViewController = storyboard?.instantiateViewController(identifier: String(describing: EventViewController.self)) as? EventViewController else{
            return nil
        }
        
        eventViewController.index = index
        eventViewController.eventName = events[index].eventName
        eventViewController.bgImageName = events[index].imageName
        eventViewController.infoLinkURL = events[index].infoLinkURL
        eventViewController.dateTime = events[index].eventDateTime
        eventViewController.location = events[index].eventLocation
        
        return eventViewController
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension CommunityViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate{
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currViewIndex
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return events.count
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore before: UIViewController) -> UIViewController? {
        
        let eventViewController = before as? EventViewController
        
        guard var currIndex = eventViewController?.index else{
            return nil
        }
        
        currViewIndex = currIndex
        
        if currIndex == 0{
            currIndex = events.count-1
        } else{
            currIndex -= 1
        }
    
        return detailViewController(index: currIndex)
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter after: UIViewController) -> UIViewController? {
        let eventViewController = after as? EventViewController
        
        guard var currIndex = eventViewController?.index else{
            return nil
        }
        
        currViewIndex = currIndex
        
        if currIndex == events.count - 1{
            currIndex = 0;
        } else{
            currIndex += 1
        }
        return detailViewController(index: currIndex)
    }
}
