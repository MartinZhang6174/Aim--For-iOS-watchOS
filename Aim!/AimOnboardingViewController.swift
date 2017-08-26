//
//  AimOnboardingViewController.swift
//  Aim!
//
//  Created by Martin Zhang on 2017-08-10.
//  Copyright © 2017 Martin Zhang. All rights reserved.
//

import UIKit
import paper_onboarding
import DeviceKit

class AimOnboardingViewController: UIViewController, PaperOnboardingDataSource, PaperOnboardingDelegate {

    @IBOutlet weak var getStartedButton: UIButton!
    @IBOutlet weak var onboardingView: PaperOnboarding!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        onboardingView.dataSource = self
        onboardingView.delegate = self
    }

    func onboardingItemsCount() -> Int {
        return 5
    }
    
    func onboardingItemAtIndex(_ index: Int) -> OnboardingItemInfo {
        
        let titleFont = UIFont(name: "PhosphatePro-Inline", size: 27)!
        let descriptionFont = UIFont.systemFont(ofSize: 18)
        
        return [(UIImage(named: "singleBook")!, "Ever felt distracted?", "Studying or focusing with your iPhone is sometimes hard. Most people have trouble not using their device every five minutes. That is what made us realized the demand for an application to help people with staying on task.", #imageLiteral(resourceName: "doubleBooksRoundIcon"), aimApplicationThemePurpleColor, aimApplicationThemeOrangeColor, aimApplicationThemeOrangeColor, titleFont, descriptionFont),
                
                (UIImage(named: "aimTitleLogo")!, "Luckily we have Aim!", "Aim! is an app designed to help people regain focus on their work, academics, or quality coffee time!", #imageLiteral(resourceName: "appBlueprintIcon"), aimApplicationThemeOrangeColor, aimApplicationThemePurpleColor, aimApplicationThemePurpleColor, titleFont, descriptionFont),
                
                (UIImage(named: "notificationTitle")!, "Get motivated daily.", "Setting reminders throughout your week encourages you to get on track with your tasks.", #imageLiteral(resourceName: "bellIcon"), aimApplicationThemePurpleColor, aimApplicationThemeOrangeColor, aimApplicationThemeOrangeColor, titleFont, descriptionFont),
                
                (UIImage(named: "awardTitle")!, "Receive awards.", "Getting awards from the app for your activities on Aim! is a fun way to be reminded of your commitment!", #imageLiteral(resourceName: "trophyIcon"), aimApplicationThemeOrangeColor, aimApplicationThemePurpleColor, aimApplicationThemePurpleColor, titleFont, descriptionFont),
            
                (UIImage(named: "aimATitle")!, "Ready to get started?", "Click button below to start your first session.", #imageLiteral(resourceName: "checkMarkIcon"), aimApplicationThemePurpleColor, aimApplicationThemeOrangeColor, aimApplicationThemeOrangeColor, titleFont, descriptionFont)][index]
    }
    
    func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index: Int) {
        
    }
    
    func onboardingWillTransitonToIndex(_ index: Int) {
        
    }
    
    func onboardingDidTransitonToIndex(_ index: Int) {
        if index == 3 {
            if getStartedButton.alpha == 1 {
                UIView.animate(withDuration: 0.3, animations: { 
                    self.getStartedButton.alpha = 0
                    self.getStartedButton.isEnabled = false
                })
            }
        }
        
        if index == 4 {
            UIView.animate(withDuration: 0.7, animations: { 
                self.getStartedButton.alpha = 1
                self.getStartedButton.isEnabled = true
            })
        }
    }
    
    @IBAction func getStartedButtonClicked(_ sender: Any) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(true, forKey: "CompletedOnboarding")
        userDefaults.synchronize()
    }
    
    /*
    // MARK: - Navigation®

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
