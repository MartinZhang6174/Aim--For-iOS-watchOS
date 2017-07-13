//
//  AimAwardsViewController.swift
//  Aim!
//
//  Created by Martin Zhang on 2017-03-18.
//  Copyright © 2017 Martin Zhang. All rights reserved.
//

import UIKit
import Firebase

class AimAwardsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var aimAwardsCollectionView: UICollectionView!
    
    var awardStringDict = [String: Any]()
    var awardStringArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.automaticallyAdjustsScrollViewInsets = false

        self.navigationController?.navigationBar.barTintColor = aimApplicationNavBarThemeColor
        self.view.backgroundColor = aimApplicationThemePurpleColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let ref = Database.database().reference()
        ref.child("users").child((Auth.auth().currentUser?.uid)!).child("Awards").observeSingleEvent(of: .value, with: { (snapshot) in
            self.awardStringDict = snapshot.value as! [String : Any]
            let lazyMapCollection = self.awardStringDict.keys
            self.awardStringArray = Array(lazyMapCollection)
            print(self.awardStringArray)
            
            self.aimAwardsCollectionView.delegate = self
            self.aimAwardsCollectionView.dataSource = self
            
            self.aimAwardsCollectionView.reloadData()
        })
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return awardStringArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = aimAwardsCollectionView.dequeueReusableCell(withReuseIdentifier: "AwardCell", for: indexPath) as! AimAwardsBadgeCollectionViewCell
        
        let cellImageName = awardStringArray[indexPath.row]
        cell.badgeImageView.image = UIImage(named: cellImageName)
        cell.badgeLabel.text = "Hahaha"
        
        return cell
    }
    
    @IBAction func doneButtonClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
