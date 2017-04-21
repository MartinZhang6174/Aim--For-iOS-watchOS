//
//  AimSessionSelectionMainViewController.swift
//  Aim!
//
//  Created by Martin Zhang on 2017-03-01.
//  Copyright © 2017 Martin Zhang. All rights reserved.
//

import UIKit
import MobileCoreServices
import Firebase

let aimApplicationThemeOrangeColor = hexStringToUIColor(hex: "FF4A1C")
let aimApplicationThemePurpleColor = hexStringToUIColor(hex: "1A1423")
let aimApplicationNavBarThemeColor = hexStringToUIColor(hex: "1A1421")

@IBDesignable
class AimSessionSelectionMainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    let quotesAPIKey = "1fz_Wkqa9BGXusXp1WWkWQeF"
    var quoteCategory = "success"
    
    let aimApplicationThemeFont24 = UIFont(name: "PhosphatePro-Inline", size: 24)
    
    var togglingCell = false
    var selectedCellIndexPath: IndexPath? = nil
    
    @IBOutlet weak var aimSessionCollectionView: UICollectionView!
    @IBOutlet weak var userLoginStatusIndicatorLabel: UILabel!
    @IBOutlet weak var aimTokenSumLabel: UILabel!
    @IBOutlet weak var aimTokenHourSeparaterImageView: UIImageView!
    @IBOutlet weak var aimHourSumLabel: UILabel!
    @IBOutlet weak var uploadProgressView: UIProgressView!
    @IBOutlet var addSessionPopupView: AimSessionAddingPopUpView!
    @IBOutlet weak var quoteLabel: UILabel!
    
    // var sessionNameArray = ["Physics", "Calculus", "Programming", "Vocabulary", "Aerodynamics"]
    
    
    var sessionObjectArray = [AimSession]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // getting quote:
        let quoteFetchingURL = URL(string: "http://quotes.rest/quote/search.json?api_key=\(quotesAPIKey)&category=\(quoteCategory)")!
        let quoteFetchTask = URLSession.shared.dataTask(with: quoteFetchingURL) { (data, response, error) in
            if error != nil {
                print("\(error!.localizedDescription)>>>>>>>>>>>>>>>>>>>>>>>>>>>")
            } else {
                if let jsonUnformatted = try? JSONSerialization.jsonObject(with: data!, options: []) {
                    let json = jsonUnformatted as? [String: AnyObject]
                    let content = json?["contents"] as? [String: AnyObject]
                    let quoteString = content?["quote"] as? String
                    print("\(quoteString)<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<")
                    
                    if let quote = quoteString {
                        OperationQueue.main.addOperation {
                            self.quoteLabel.text = quote
                        }
                    }
                }
            }
        }
        quoteFetchTask.resume()
        
        
        // Fake data:
        let fmt = DateFormatter()
        fmt.dateFormat = "dd.MM.yyyy"
        
        let date1 = fmt.date(from: "15.09.2016")
        let date2 = fmt.date(from: "10.07.2016")
        let date3 = fmt.date(from: "05.02.2017")
        let date4 = fmt.date(from: "16.04.2017")
        
        let session1 = AimSession(sessionTitle: "Physics", dateInitialized: date1!, image: UIImage(named: "knowledge1")!, priority: false)
        let session2 = AimSession(sessionTitle: "Calculus", dateInitialized: date2!, image: UIImage(named: "knowledge2")!, priority: false)
        let session3 = AimSession(sessionTitle: nil, dateInitialized: date3!, image: UIImage(named: "knowledge3")!, priority: false)
        let session4 = AimSession(sessionTitle: "Aero", dateInitialized: date4!, image: UIImage(named: "knowledge4")!, priority: false)
        
        
        self.sessionObjectArray.append(session1)
        self.sessionObjectArray.append(session2)
        self.sessionObjectArray.append(session3)
        self.sessionObjectArray.append(session4)
        
        
        // Putting Aim! logo onto nav bar:
        let navBarAimLogo = UIImage(named: "aim!LogoForNavigationBar")
        self.navigationItem.titleView = UIImageView.init(image: navBarAimLogo)
        // Setting nav bar item colors:
        self.navigationItem.leftBarButtonItem?.tintColor = aimApplicationThemeOrangeColor
        self.navigationItem.rightBarButtonItem?.tintColor = aimApplicationThemeOrangeColor
        
        // Set background color: (For some reason I could not match the color I designed in Sketch 3 with the bg color I set in storyboard; therefore, I manually set hex color value onto each UIView element which needs a customized color)
        self.view.backgroundColor = aimApplicationThemePurpleColor
        aimTokenSumLabel.textColor = aimApplicationThemeOrangeColor
        aimTokenHourSeparaterImageView.backgroundColor = aimApplicationThemeOrangeColor
        aimHourSumLabel.textColor = aimApplicationThemeOrangeColor
        
        self.navigationController?.navigationBar.barTintColor = aimApplicationNavBarThemeColor
        
        let plusObject = AimSession(sessionTitle: "+", dateInitialized: nil, image: nil, priority: false)
        self.sessionObjectArray.append(plusObject)
        
        self.aimSessionCollectionView.isUserInteractionEnabled = true
        // aimSessionCollectionView.delegate = self
        
        // Use custom PhosphatePro-Inline font
        aimTokenSumLabel.font = aimApplicationThemeFont24
        aimHourSumLabel.font = aimApplicationThemeFont24
        
        aimSessionCollectionView.backgroundColor = aimApplicationThemePurpleColor
        
        // self.addSessionPopupView.layer.cornerRadius = 5.0
        
        // Check user login status
        if FIRAuth.auth()?.currentUser?.uid == nil {
            perform(#selector(handleLoginRegister), with: nil, afterDelay: 0)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        var userLoginStatus = false
        let userLoginEmail = FIRAuth.auth()?.currentUser?.email
        if FIRAuth.auth()?.currentUser?.uid != nil {
            userLoginStatus = true
        } else {
            userLoginStatus = false
        }
        userLoginStatusIndicatorLabel.text = "\(userLoginStatus)\n\(userLoginEmail)"
    }
    
    func handleLoginRegister() {
        performSegue(withIdentifier: "showLoginPageSegue", sender: self)
    }
    
    @IBAction func signOutButtonPressed(_ sender: Any) {
        do {
            try FIRAuth.auth()?.signOut()
        } catch let signOutError {
            print(signOutError)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Returning the number of items in sessionDict plus one for the last cell is going to be an ADD button
        return sessionObjectArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sessionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "aimSessionSelectionCollectionViewCell", for: indexPath) as! AimSessionSelectionVCCollectionViewCell
        
        let selectedAimSessionObject = sessionObjectArray[indexPath.row]
        
        // If the cell that is getting configured is the last cell that's supposed to show up on the collection view,
        if indexPath.row == sessionObjectArray.count-1 {
            // Hide black view and move label to centre of cell displaying huge "+"
            sessionCell.backgroundBlackView.isHidden = true
            
            // Put constraints in relative to the entire cell rather than to the black view normally
            sessionCell.sessionInfoLabel.centerYAnchor.constraint(equalTo: sessionCell.centerYAnchor, constant: -4).isActive = true
            sessionCell.sessionInfoLabel.leadingAnchor.constraint(equalTo: sessionCell.leadingAnchor).isActive = true
            sessionCell.sessionInfoLabel.trailingAnchor.constraint(equalTo: sessionCell.trailingAnchor).isActive = true
            
            // Remove cell image, show orange background
            // sessionCell.sessionSnaphotImageView.image = nil
            
            sessionCell.sessionInfoLabel.text = "+"
            sessionCell.sessionInfoLabel.font = UIFont(name: "PhosphatePro-Inline", size: 78)
            sessionCell.sessionInfoLabel.textColor = aimApplicationThemePurpleColor
            sessionCell.backgroundColor = aimApplicationThemeOrangeColor
            sessionCell.sessionSnaphotImageView.image = nil
        } else {
            if selectedAimSessionObject.title != nil {
                sessionCell.sessionInfoLabel.text = sessionObjectArray[indexPath.row].title
            } else {
                sessionCell.backgroundBlackView.isHidden = true
                sessionCell.sessionInfoLabel.isHidden = true
            }
            sessionCell.sessionSnaphotImageView.image = selectedAimSessionObject.image
            // sessionCell.layer.masksToBounds = false
        }
        return sessionCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        self.selectedCellIndexPath = indexPath
        let selectedCell = collectionView.cellForItem(at: selectedCellIndexPath!)
        
        //selectedCell?.layer.shadowOpacity = 1.0
        //selectedCell?.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        //selectedCell?.layer.shadowRadius = 3.0
        
        UIView.animate(withDuration: 0.3) {
            selectedCell?.layoutIfNeeded()
        }
        
        // Disable user interaction so no one can keep clicking cell like crazayyy
        // self.aimSessionCollectionView.isUserInteractionEnabled = false
        
        // togglingCell = true
        
        /*
         if togglingCell {
         UIView.animate(withDuration: 0.3, animations: {
         selectedCell?.alpha = 0.5
         })
         } else {
         print("I ain't adding nothing!")
         }
         //if indexPath.row == sessionNameArray.count-1 {
         // self.aimSessionCollectionView.isUserInteractionEnabled = false
         //}*/
        // self.addSessionPopupView.isUserInteractionEnabled = false
        
        
    }
    
    var viewAccumulationArrray = [UIView]()
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedCellIndexPath = indexPath
        let selectedCell = collectionView.cellForItem(at: selectedCellIndexPath!)
        
        togglingCell = true
        
        if togglingCell {
            UIView.animate(withDuration: 0.3, animations: {
                selectedCell?.alpha = 0.5
            }, completion: { (finishedAnimating) in
                // self.aimSessionCollectionView.isUserInteractionEnabled = false
                // self.addSessionPopupView.isUserInteractionEnabled = true
            }) } else {
            print("I ain't adding nothing!")
        }
        
        // If this isn't yet the last, do an USUAL configuration:
        if indexPath.row == sessionObjectArray.count-1 {
            print("Last")
            animatePopupIn()
        } else {
            print("Nope")
            // selectedCell?.isUserInteractionEnabled = false
            selectedCell?.alpha = 1.0
        }
    }
    
    func animatePopupIn() {
        self.view.addSubview(addSessionPopupView)
        
        addSessionPopupView.frame = CGRect(x: self.view.bounds.size.width/2-135, y: self.view.bounds.size.height, width: 270, height: 210)
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
            self.addSessionPopupView.frame = CGRect(x: self.view.bounds.size.width/2-135, y: self.view.bounds.size.height/2-85, width: 270, height: 170)
        }, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath)
        /*selectedCell?.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
         selectedCell?.layer.shadowRadius = 5.0
         selectedCell?.layer.shadowOpacity = 0.7
         selectedCell?.layer.masksToBounds = false*/
        
        //UIView.animate(withDuration: 0.3) {
        selectedCell?.layoutIfNeeded()
        //}
    }
    
    @IBAction func closeButtonOnPopupClicked(_ sender: Any) {
        togglingCell = false
        let selectedCell = collectionView(aimSessionCollectionView, cellForItemAt: selectedCellIndexPath!)
        // Allow user interaction back on
        // aimSessionCollectionView.isUserInteractionEnabled = true
        
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
            self.addSessionPopupView.frame = CGRect(x: self.view.bounds.size.width/2-135, y: -250, width: 270, height: 210)
        }) { (finishedAnimating) in
            self.addSessionPopupView.removeFromSuperview()
            // self.viewAccumulationArrray.append(self.addSessionPopupView)
            
            if !self.togglingCell {
                selectedCell.alpha = 1.0
            }
        }
        
        selectedCell.layoutIfNeeded()
        
        // print(viewAccumulationArrray.count)
    }
    
    // Testing button for firebase storage
    @IBAction func addSessionButtonPressed(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
        
        /*let storage = FIRStorage.storage()
         let storageRef = storage.reference()*/
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let mediaType: String = info[UIImagePickerControllerMediaType] as? String else {
            dismiss(animated: true, completion: nil)
            return
        }
        if mediaType == (kUTTypeImage as String) {
            if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage,
                let imageData = UIImageJPEGRepresentation(originalImage, 0.8) {
                uploadImageToFirebaseStorage(data: imageData)
            }
        } else if mediaType == (kUTTypeMovie as String) {
            if let movieURL = info[UIImagePickerControllerMediaURL] as? URL {
                uploadMovieToFirebaseStorage(url: movieURL)
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    func uploadImageToFirebaseStorage(data: Data) {
        let storageRef = FIRStorage.storage().reference(withPath: "myPics/demoPic(\(data.description)).jpg")
        let uploadMetadata = FIRStorageMetadata()
        uploadMetadata.contentType = "image/jpeg"
        let uploadTask = storageRef.put(data, metadata: uploadMetadata) { (metadata, error) in
            if (error != nil) {
                print("\(error?.localizedDescription)")
            } else {
                print("\(metadata)")
            }
        }
        uploadTask.observe(.progress) { [weak self] (snapshot) in
            guard let strongSelf = self else { return }
            guard let progress = snapshot.progress else { return }
            strongSelf.uploadProgressView.progress = Float(progress.fractionCompleted)
        }
    }
    
    func uploadMovieToFirebaseStorage(url: URL) {
        
    }
    
    @IBAction func resetProgressButtonPressed(_ sender: Any) {
        self.uploadProgressView.progress = 0.0
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
