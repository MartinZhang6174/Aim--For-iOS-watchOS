//
//  AimSessionSelectionVCCollectionViewCell.swift
//  Aim!
//
//  Created by Martin Zhang on 2017-03-18.
//  Copyright © 2017 Martin Zhang. All rights reserved.
//

import UIKit

class AimSessionSelectionVCCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var sessionInfoLabel: UILabel!
    @IBOutlet weak var backgroundBlackView: UIView!
    @IBOutlet weak var sessionSnaphotImageView: UIImageView!
    @IBOutlet weak var addSessionPlusIconLabel: UILabel!
    
    override func awakeFromNib() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = true
        
        sessionSnaphotImageView.image = nil
        sessionInfoLabel.text = ""
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if #available(iOS 10.0, *) {
                if traitCollection.forceTouchCapability == UIForceTouchCapability.available {
                    let force = (touch.force)/(touch.maximumPossibleForce)
                    print("Force: \(force)")
                    if force > 0.4 {
                        super.touchesBegan(touches, with: event)
                    }
                }
            }
        }
        
    }
    
    override func prepareForReuse() {
        // Hide the regular text label, plus label and backgroundBlackView
        sessionInfoLabel.isHidden = true
        addSessionPlusIconLabel.isHidden = true
        backgroundBlackView.isHidden = true
        sessionSnaphotImageView.image = nil
    }
    
    func configure(from session: AimSession) {
        sessionInfoLabel.isHidden = false
        sessionInfoLabel.text = session.title
        backgroundBlackView.isHidden = false
        
        if let sessionImageURL = session.imageURL {
            let url = URL(string: sessionImageURL)
            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, err) in
                if err != nil {
                    print("Error has occured during image fetching: \(String(describing: err))")
                    return
                }
                
                // Nothing went wrong, continue constructing session object:
                DispatchQueue.main.async(execute: {
                    self.sessionSnaphotImageView.image = UIImage(data: data!)
                })
                
                
            }).resume()
        }
    }
    
    func configureForNewSession(){
        
        addSessionPlusIconLabel.isHidden = false
        addSessionPlusIconLabel.textColor = aimApplicationThemePurpleColor
        
    }
    
}
