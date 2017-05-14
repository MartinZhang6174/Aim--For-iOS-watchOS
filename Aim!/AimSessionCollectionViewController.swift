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
    
    let aimSessionDurationTexts = ["25 Minutes", "60 Minutes", "Custom Duration", "Endless Duration"]
    var collectionViewCells = [UICollectionViewCell]()
    var delegate: DurationDelegate?
    
    // CODEREVIEW: This code has no new functionality.  Cleanup by removing code you don't need.
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        //        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Do any additional setup after loading the view.
    }
  

    // CODEREVIEW: This code has no new functionality.  Cleanup by removing code you don't need.
  
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
  
    // CODEREVIEW: What is the purpose of the #warning comments?  The implementation is correct, so considering removing the comment as it may cause more confusion.
  
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    // CODEREVIEW: What is the purpose of the #warning comments?  The implementation is correct, so considering removing the comment as it may cause more confusion.
  
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
      
        // CODEREVIEW: What is so special about 4?  Using literals other than 1 or 0 is typically poor form.  Use a constant (e.g. NumberOfCarModels, NumberOfCarMakers) or use a calculated property related to the data source of the collection view.  (e.g. carModels.count() or carMakers.count() or whatever is appropriate for this collectionView)
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Casting as UICollectionViewCell: MAY change
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! UICollectionViewCell
        
        // Configure the cell
      
        // CODEREVIEW: Remove commented code.  While you're still working on the code it is normal to have commented code.  But when you're ready to have the code reviewed and potentially merged to master, make sure it's cleaned up and all the unneeded code is removed.
      
        self.collectionViewCells.append(cell)
        // cell.sessionInfoLabel.text = self.aimSessionDurationTexts[indexPath.item]
        // cell.backgroundColor = UIColor.blue
        cell.layer.borderColor = UIColor.clear.cgColor
        cell.layer.borderWidth = 4
        cell.layer.cornerRadius = 16
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected item #\(indexPath.item)")
        
        switch indexPath.item {
        case 0:
            // 25 minutes
            // Lead users to session directly if no need to customize durations
            self.performSegue(withIdentifier: "startAimSessionWithSpecifiedDurationSegue", sender: self)
            if let delegate = self.delegate {
                delegate.beginCustomSession(durationInSeconds: (25 * 60))
            }
        case 1:
            // 60 minutes
            // Lead users to session directly if no need to customize durations
            self.performSegue(withIdentifier: "startAimSessionWithSpecifiedDurationSegue", sender: self)
            if let delegate = self.delegate {
                delegate.beginCustomSession(durationInSeconds: (60 * 60))
            }
        case 2:
            // Custom duration controller
            self.performSegue(withIdentifier: "goToSessionCustomizationViewSegue", sender: self)
        default:
            // Unspecified session duration
            self.performSegue(withIdentifier: "startAimSessionWithSpecifiedDurationSegue", sender: self)
            if let delegate = self.delegate {
                delegate.beginEndlessSession()
            }
        }
      
        // CODEREVIEW: Remove commented code.
      
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
    
    // CODEREVIEW: Remove commented code.

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
