//
//  AimAwardsViewController.swift
//  Aim!
//
//  Created by Martin Zhang on 2017-03-18.
//  Copyright © 2017 Martin Zhang. All rights reserved.
//

import UIKit
import Firebase
import MarqueeLabel

class AimAwardsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var aimAwardsCollectionView: UICollectionView!
    
    let awardManager = AimAwardManager()
    
    var awardStringDict = [String: Any]()
    var awardStringArray = [String]()
    var awardDescriptionsArray = [String]()
    
    var awardArray = [AimAwardBadge]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.navigationController?.navigationBar.barTintColor = aimApplicationNavBarThemeColor
        self.view.backgroundColor = aimApplicationThemePurpleColor
    }

    override func viewDidAppear(_ animated: Bool) {
        let ref = Database.database().reference()
        if let currentUserID = Auth.auth().currentUser?.uid {
            ref.child("users").child(currentUserID).child("Awards").observeSingleEvent(of: .value, with: { (snapshot) in
                if let awardsDict = snapshot.value as? [String: Any] {
                    self.awardStringDict = awardsDict
                    let lazyMapCollection = self.awardStringDict.keys
                    self.awardStringArray = Array(lazyMapCollection)
                    print(self.awardStringArray)
                    
                    for awardString in self.awardStringArray {
                        let awardDescription = self.awardManager.getAwardDescription(for: awardString)
                        let awardBadgeObj = AimAwardBadge(title: awardString, badgeDesc: awardDescription)
                        
                        self.awardArray.insert(awardBadgeObj, at: 0)
                    }
                    self.aimAwardsCollectionView.delegate = self
                    self.aimAwardsCollectionView.dataSource = self
                    
                    self.aimAwardsCollectionView.reloadData()
                }
            })
        } else {
            let notification = AimStandardStatusBarNotification()
            notification.display(withMessage: "Please login to see your achievements!", forDuration: 1.5)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return awardArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = aimAwardsCollectionView.dequeueReusableCell(withReuseIdentifier: "AwardCell", for: indexPath) as! AimAwardsBadgeCollectionViewCell
        
        let awardObj = awardArray[indexPath.row]
        
        cell.badgeImageView.image = UIImage(named: awardObj.badgeTitle!)
        
        cell.badgeLabel.animationCurve = .curveEaseInOut
        cell.badgeLabel.fadeLength = 5.0
        cell.badgeLabel.lineBreakMode = .byTruncatingHead
        cell.badgeLabel.text = awardObj.badgeDescription
        cell.badgeLabel.scrollDuration = 9.0
        cell.badgeLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 20)
        cell.badgeLabel.marqueeType = .MLContinuous
        cell.badgeLabel.tapToScroll = true
        
        return cell
    }
    
    @IBAction func doneButtonClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
