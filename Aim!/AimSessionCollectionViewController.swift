//
//  AimSessionCollectionViewController.swift
//  Aim!
//
//  Created by Martin Zhang on 2016-10-15.
//  Copyright © 2016 Martin Zhang. All rights reserved.
//

import UIKit

private let reuseIdentifier = "aimSessionsCell"

class AimSessionCollectionViewController: UICollectionViewController {
    
    let aimSessionDurationTexts = ["25-Minute-Long Session", "Hour-Long Session", "Custom-Duration Session", "Endless-Duration Session"]
    var collectionViewCells = [AimSessionsCollectionViewCell]()
    var delegate: DurationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 4
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! AimSessionsCollectionViewCell
    
        // Configure the cell
        
        cell.anAimSessionButtonLabel.text = self.aimSessionDurationTexts[indexPath.item]
        self.collectionViewCells.append(cell)
    
        return cell
    }

    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected item #\(indexPath.item)")
        
        switch indexPath.item {
        case 1:
            // 25 minutes
            // Lead users to session directly if no need to customize durations
            self.performSegue(withIdentifier: "startAimSessionWithSpecifiedDurationSegue", sender: self)
            if let delegate = self.delegate {
                delegate.beginCustomSession(durationInSeconds: (25 * 60))
            }
        case 2:
            // 60 minutes
            // Lead users to session directly if no need to customize durations
            self.performSegue(withIdentifier: "startAimSessionWithSpecifiedDurationSegue", sender: self)
            if let delegate = self.delegate {
                delegate.beginCustomSession(durationInSeconds: (60 * 60))
            }
        case 3:
            // Custom duration controller
            self.performSegue(withIdentifier: "goToSessionCustomizationViewSegue", sender: self)
        default:
            // Unspecified session duration
            self.performSegue(withIdentifier: "startAimSessionWithSpecifiedDurationSegue", sender: self)
            if let delegate = self.delegate {
                delegate.beginEndlessSession()
            }
        }
//        
//        if collectionViewCells[indexPath.row].anAimSessionButtonLabel.text == "25-Minute-Long Session" {
//
//            
//        } else if collectionViewCells[indexPath.row].anAimSessionButtonLabel.text == "Custom-Duration Session" {
//        
//            // Lead users to session customization screen if customization needed
//            self.performSegue(withIdentifier: "goToSessionCustomizationViewSegue", sender: self)
//            
//        } else {
//        
//            // Lead users to the same VC as the "startAimSessionWithSpecifiedDurationSegue" but with no time limit
//            // TODO: start working on delegation and remove time limit for limitless session
//            self.performSegue(withIdentifier: "startAimSessionWithSpecifiedDurationSegue", sender: self)
//        }
//
//        

    }

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
