//
//  AimSessionSelectionMainViewController.swift
//  Aim!
//
//  Created by Martin Zhang on 2017-03-01.
//  Copyright © 2017 Martin Zhang. All rights reserved.
//

import UIKit
import MobileCoreServices
import NVActivityIndicatorView
import Firebase
import RealmSwift
import WatchConnectivity
import CWStatusBarNotification

let aimApplicationThemeOrangeColor = hexStringToUIColor(hex: "FF4A1C")
let aimApplicationThemePurpleColor = hexStringToUIColor(hex: "1A1423")
let aimApplicationNavBarThemeColor = hexStringToUIColor(hex: "1A1421")

let NotificationUpdatedTokenFromWatch = "ReceivedUpdatedTokensFromWatchNotification"

class AimSessionSelectionMainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    let aimApplicationThemeFont24 = UIFont(name: "PhosphatePro-Inline", size: 24)
    
    let toPopupVCSegueIdentifier = "segueToPopupViewController"
    let toSessionSegueIdentifier = "mainMenuToSessionSegue"
    
    var delegate: AimSessionDurationInfoDelegate?
    var sessionManager = SessionDurationManager()
    
    // let quotesAPIKey = "1fz_Wkqa9BGXusXp1WWkWQeF"
    var quoteCategory = "success"
    var quoteMaxCharRestriction = 120
    
    let fmt = DateFormatter()
    
    var togglingLastCell = false
    var selectedCellIndexPath: IndexPath? = nil
    var authorFlipped = false
    
    // Generating Firebase realtime database reference for reading & writing data
    var ref: DatabaseReference?
    var databaseHandle: DatabaseHandle?
    //    var sessionObjectArray = [AimSession]()
    var aimSessionFetchedArray = [AimSession]()
    
    @IBOutlet var aimSessionCollectionView: UICollectionView!
    @IBOutlet weak var aimTokenSumLabel: UILabel!
    @IBOutlet weak var aimTokenHourSeparaterImageView: UIImageView!
    @IBOutlet weak var aimHourSumLabel: UILabel!
    @IBOutlet var addSessionPopupView: AimSessionAddingPopUpView!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var quoteAuthorLabel: UILabel!
    @IBOutlet weak var quoteView: AimQuoteView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let quoteLoadingIndicatorViewFrameRect = CGRect(x: self.view.center.x-25, y: self.quoteLabel.center.y-20, width: 50, height: 50)
        
        let quoteLoadingView = NVActivityIndicatorView(frame: quoteLoadingIndicatorViewFrameRect, type: NVActivityIndicatorType.ballRotate, color: aimApplicationThemeOrangeColor, padding: NVActivityIndicatorView.DEFAULT_PADDING)
        self.moveLoadingView(loadingView: quoteLoadingView)
        
        self.quoteView.isUserInteractionEnabled = false
        
        aimTokenHourSeparaterImageView.layer.cornerRadius = 0.50
        
        var keys: NSDictionary?
        
        if let path = Bundle.main.path(forResource: "AimKeys", ofType: "plist") {
            keys = NSDictionary(contentsOfFile: path)
        }
        if let dict = keys {
            if let quotesAPIKey = dict["QuotesAPIKey"] as? String {
                // Getting quote content & author name:
                let quoteFetchingURL = URL(string: "http://quotes.rest/quote/search.json?api_key=\(quotesAPIKey)&category=\(quoteCategory)&maxlength=\(quoteMaxCharRestriction)")!
                let quoteFetchTask = URLSession.shared.dataTask(with: quoteFetchingURL) { (data, response, error) in
                    if error != nil {
                        print("\(error!.localizedDescription)")
                        self.endLoadingView(movingLoadingView: quoteLoadingView)
                        
                        let statusBarNotification = AimStandardStatusBarNotification()
                        OperationQueue.main.addOperation {
                            statusBarNotification.display(withMessage: "Internet connection is down.", forDuration: 2.0)
                        }
                        return
                    } else {
                        if let jsonUnformatted = try? JSONSerialization.jsonObject(with: data!, options: []) {
                            let json = jsonUnformatted as? [String: AnyObject]
                            let content = json?["contents"] as? [String: AnyObject]
                            let quoteString = content?["quote"] as? String
                            let quoteAuthorName = content?["author"] as? String
                            
                            if let quote = quoteString {
                                // Quote loading task completed:
                                OperationQueue.main.addOperation {
                                    self.quoteView.isUserInteractionEnabled = true
                                    self.endLoadingView(movingLoadingView: quoteLoadingView)
                                    self.quoteLabel.text = quote
                                    if quoteAuthorName != nil {
                                        self.quoteAuthorLabel.text = "by  " + quoteAuthorName!
                                    } else {
                                        self.quoteAuthorLabel.text = "Anonymous"
                                    }
                                    
                                    UIView.animate(withDuration: 0.4, animations: {
                                        self.view.layoutIfNeeded()
                                    }, completion: { (finished) in
                                        print("Finished animating. <<<<<<<<<<<<<<<<<<<<<<<")
                                    })
                                }
                            }
                        }
                    }
                }
                quoteFetchTask.resume()
            }
            }
        
        
        // Prepare for notifications from apple watch's token update:
        NotificationCenter.default.addObserver(self, selector: #selector(handleTokenSumLabelUpdate), name: Notification.Name(NotificationUpdatedTokenFromWatch), object: UIApplication.shared.delegate)
        
        // Putting Aim! logo onto nav bar:
        let navBarAimLogo = UIImage(named: "aim!LogoForNavigationBar")
        self.navigationItem.titleView = UIImageView.init(image: navBarAimLogo)
        
        // Set background color: (For some reason I could not match the color I designed in Sketch 3 with the bg color I set in storyboard; therefore, I manually set hex color value onto each UIView element which needs a customized color)
        aimTokenSumLabel.textColor = aimApplicationThemeOrangeColor
        aimTokenHourSeparaterImageView.backgroundColor = aimApplicationThemeOrangeColor
        aimHourSumLabel.textColor = aimApplicationThemeOrangeColor
        
        // Setting navigation bar tint colour to theme purple(for nav bar only)
        self.navigationController?.navigationBar.barTintColor = aimApplicationNavBarThemeColor
        
        self.aimSessionCollectionView.isUserInteractionEnabled = true
        
        // Use custom PhosphatePro-Inline font
        aimTokenSumLabel.font = aimApplicationThemeFont24
        aimHourSumLabel.font = aimApplicationThemeFont24
        
        aimSessionCollectionView.alwaysBounceVertical = true
        
        // Check user login status
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLoginRegister), with: nil, afterDelay: 0)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Setting the database reference:
        ref = Database.database().reference()
        
        // Setting date format for formatter
        fmt.dateFormat = "dd.MM.yyyy"
        
        // Clean up session fetched array to avoid duplications
        aimSessionFetchedArray.removeAll()
        
        quoteAuthorLabel.isHidden = false
        quoteView.isHidden = false
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: Date())
        let todayString = "\(components.year!)\(components.month!)\(components.day!)"
        if Auth.auth().currentUser?.uid != nil {
            if let numberOfSessionsArray = UserDefaults.standard.array(forKey: todayString) as? [Int] {
                print(numberOfSessionsArray)
                if numberOfSessionsArray.count >= 3 {
                    awardUserThreeBadge()
                }
                
                if numberOfSessionsArray.count >= 4 {
                    awardUserFourBadge()
                }
                
                if numberOfSessionsArray.count >= 5 {
                    awardUserFiveBadge()
                }
            }
        }
        
        // If user is logged in:
        if let currentUserID = Auth.auth().currentUser?.uid as String! {
            let realm = try! Realm()
            
            ref?.child("users").child((Auth.auth().currentUser?.uid)!).child("Tokens").observeSingleEvent(of: .value, with: { (snapshot) in
                if let tokensFetched = snapshot.value as? Float {
                    let localUserObj = realm.object(ofType: AimUser.self, forPrimaryKey: Auth.auth().currentUser?.email)
                    do {
                        try realm.write {
                            localUserObj?.tokenPool = tokensFetched
                            realm.add(localUserObj!, update: true)
                        }
                        if let userInRealm = realm.object(ofType: AimUser.self, forPrimaryKey: Auth.auth().currentUser?.email) {
                            DispatchQueue.main.async {
                                self.aimTokenSumLabel.text = "\(userInRealm.tokenPool)"
                            }
                            // Transfer user info to apple watch app(maybe put this into the token sum label/button action too):
                            let userInfoValues = ["Email": userInRealm.email, "TotalTokens": userInRealm.tokenPool] as [String : Any]
                            
                            do {
                                try WCSession.default().transferUserInfo(["CurrentUser": userInfoValues])
                            } catch _ {
                                print("Error sending user info.")
                            }
                        }
                    } catch let err {
                        print(err)
                    }
                    
                }
            })
            
            // Retrieve sessions:
            databaseHandle = ref?.child("users").child(currentUserID).child("Sessions").observe(.childAdded, with: { (snapshot) in
                let sessionTitle = snapshot.key
                let sessionDateString = snapshot.childSnapshot(forPath: "DateCreated").value as? String
                let sessionDate = self.fmt.date(from: sessionDateString!)
                var sessionPriority = false
                if snapshot.childSnapshot(forPath: "Priority").value as? String == "1" {
                    sessionPriority = true
                }
                let sessionImageURL = snapshot.childSnapshot(forPath: "ImageURL").value as? String
                
                let sessionTokens: Int?
                let sessionHours: Int?
                
                if let tokens = snapshot.childSnapshot(forPath: "TotalTokens").value as? Int {
                    sessionTokens = tokens
                } else {
                    sessionTokens = 0
                }
                
                if let hours = snapshot.childSnapshot(forPath: "TotalHours").value as? Int {
                    sessionHours = hours
                } else {
                    sessionHours = 0
                }
                
                // FORCE UNWRAPPING DATE HERE BECAUSE EVERY SESSION IS SUPPOSED TO BE INITIALIZED WITH A DATE AND IMAGE URL
                let sessionObj = AimSession(sessionTitle: sessionTitle, dateInitialized: sessionDate!, sessionImageURLString: sessionImageURL!, priority: sessionPriority)
                sessionObj.currentToken = sessionTokens!
                sessionObj.hoursAccumulated = sessionHours!
                // CONSIDERING DELETING TIME INTERVAL IDEA
                if let intervals = snapshot.childSnapshot(forPath: "TotalIntervals").value as? TimeInterval {
                    sessionObj.currentTimeAccumulated = intervals
                }
                
                if self.shouldInsert(item: sessionObj, into: self.aimSessionFetchedArray) {
                    self.aimSessionFetchedArray.insert(sessionObj, at: 0)
                }
                
                // Saving sessions fetched to Realm
                if realm.object(ofType: AimSession.self, forPrimaryKey: sessionObj.imageURL) == nil {
                    do {
                        try! realm.write {
                            realm.add(sessionObj)
                        }
                    }
                }
                
                // NOT ASSIGNING TIME INTERVAL VALUE TO THIS WATCH RECEIVED OBJECT>>>>>>>>>>>>>>>><<<<<<<<<<<<<<
                let sessionInfoValues = ["Title": sessionObj.title, "DateCreated": sessionObj.dateCreated, "Priority": sessionObj.isPrioritized, "Tokens": sessionObj.currentToken, "Hours": sessionObj.hoursAccumulated] as [String: Any]
                
                // Transfer the session loaded to Apple Watch app
                do {
                    try WCSession.default().transferUserInfo(["Session": sessionInfoValues])
                } catch let error {
                    print(error)
                }
                
                // Trying to find a way to animate collectionview data reloading
                self.aimSessionCollectionView.reloadData()
                let range = Range(uncheckedBounds: (0, self.aimSessionCollectionView.numberOfSections))
                let indexSet = IndexSet(integersIn: range)
                self.aimSessionCollectionView.reloadSections(indexSet)
            })
        }
        
        var userLoginStatus = false
        let userLoginEmail = Auth.auth().currentUser?.email
        
        Auth.auth().currentUser?.uid != nil ? (userLoginStatus = true) : (userLoginStatus = false)
        
        // When user isn't logged in
        if Auth.auth().currentUser?.uid == nil {
            //            self.quoteView.isHidden = true
            //            self.quoteAuthorLabel.isHidden = true
            self.aimTokenSumLabel.text = "0.0"
            self.aimHourSumLabel.text = "0.0"
        }
        
        let realm = try! Realm()
        if userLoginStatus == true {
            // Force unwrapping user email since there's no way anyone could be in the app logged in without having an email registered with the account
            AimUser.defaultUser(in: realm, withEmail: userLoginEmail!)
        } else {
            // If the use isn't logged in, delete all session data on WATCH APP
            WCSession.default().sendMessage(["UserAuthState": false], replyHandler: nil, errorHandler: { (err) in
                print("Could not establish communications to WatchKit app.")
            })
        }
        
        let range = Range(uncheckedBounds: (0, self.aimSessionCollectionView.numberOfSections))
        let indexSet = IndexSet(integersIn: range)
        self.aimSessionCollectionView.reloadSections(indexSet)
    }
    
    func shouldInsert(item: AimSession, into list: Array<AimSession>) -> Bool {
        var shouldInsert = true
        
        for listEntry in list {
            shouldInsert = shouldInsert && (listEntry.imageURL != item.imageURL)
        }
        
        if (!shouldInsert) {
            return shouldInsert
        }
        
        return shouldInsert
    }
    
    func moveLoadingView(loadingView: NVActivityIndicatorView) {
        self.view.addSubview(loadingView)
        loadingView.startAnimating()
    }
    
    func endLoadingView(movingLoadingView: NVActivityIndicatorView) {
        movingLoadingView.stopAnimating()
        movingLoadingView.removeFromSuperview()
    }
    
    func handleLoginRegister() {
        performSegue(withIdentifier: "showLoginPageSegue", sender: self)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return aimSessionFetchedArray.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sessionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "aimSessionSelectionCollectionViewCell", for: indexPath) as! AimSessionSelectionVCCollectionViewCell
        
        // Roll back each item's configuration to its starting point in order to avoid duplicates
        sessionCell.sessionSnaphotImageView.image = nil
        sessionCell.sessionPriorityBadge.isHidden = false
        sessionCell.sessionInfoLabel.text = ""
        
        if (indexPath.row < aimSessionFetchedArray.count) {
            let aimSessionObject = aimSessionFetchedArray[indexPath.row]
            sessionCell.configure(from: aimSessionObject)
        } else {
            sessionCell.configureForNewSession()
        }
        return sessionCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if indexPath.row != aimSessionFetchedArray.count {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        } else {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedCellIndexPath = indexPath
        let selectedCell = collectionView.cellForItem(at: selectedCellIndexPath!)
        
        // Last cell pressed:
        if indexPath.row == aimSessionFetchedArray.count {
            selectedCell?.isUserInteractionEnabled = false
            UIView.animate(withDuration: 0.1, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                selectedCell?.alpha = 0.4
            }, completion: { (finished) in
                UIView.animate(withDuration: 0.4, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                    selectedCell?.alpha = 1.0
                }, completion: {(done) in
                    selectedCell?.isUserInteractionEnabled = true
                })
            })
            performSegue(withIdentifier: toPopupVCSegueIdentifier, sender: self)
            
            // If this isn't yet the last, do an USUAL configuration:
        } else {
            // Segue to specific session
            performSegue(withIdentifier: toSessionSegueIdentifier, sender: self)
            
            if let delegate = self.delegate {
                // Setting default duration for now, later will need to change to better options
                delegate.getSessionDuration(sessionManager.aimDefaultSessionDuration)
            }
        }
    }
    
    func animatePopupIn() {
        self.view.addSubview(addSessionPopupView)
        
        addSessionPopupView.frame = CGRect(x: self.view.bounds.size.width/2-135, y: self.view.bounds.size.height, width: 270, height: 210)
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
            self.addSessionPopupView.frame = CGRect(x: self.view.bounds.size.width/2-135, y: self.view.bounds.size.height/2-85, width: 270, height: 200)
        }, completion: nil)
    }
    
    @IBAction func closeButtonOnPopupClicked(_ sender: Any) {
        togglingLastCell = false
        quoteView.isUserInteractionEnabled = true
        // Commenting out below line for now, may need it to change cell appearance due selection
        // let selectedCell = collectionView(aimSessionCollectionView, cellForItemAt: selectedCellIndexPath!)
        
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
            self.addSessionPopupView.frame = CGRect(x: self.view.bounds.size.width/2-135, y: -250, width: 270, height: 210)
        }) { (finishedAnimating) in
            self.addSessionPopupView.removeFromSuperview()
        }
    }
    
    // Testing button for firebase storage
    @IBAction func addSessionButtonPressed(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
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
                let imageData = UIImageJPEGRepresentation(originalImage, 0.65) {
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
        if let uid = Auth.auth().currentUser?.uid {
            let storageRef = Storage.storage().reference(withPath: "Users/SessionImages/\(uid))/(\(data.description)).jpg")
            let uploadMetadata = StorageMetadata()
            uploadMetadata.contentType = "image/jpeg"
            storageRef.putData(data, metadata: uploadMetadata) { (metadata, error) in
                if (error != nil) {
                    print("\(String(describing: error?.localizedDescription))")
                    return
                } else {
                    print("\(String(describing: metadata))")
                }
            }
        } else {
            print("Please login to use feature.")
        }
    }
    
    // To be implemented(or no):
    func uploadMovieToFirebaseStorage(url: URL) {
        
    }
    
    @IBAction func quoteViewDragged(_ sender: UIPanGestureRecognizer) {
        let quoteViewOriginalCentre = CGPoint(x: self.view.center.x, y: 43)
        let quoteCard = sender.view
        let point = sender.translation(in: self.view)
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        
        quoteCard?.center = CGPoint(x: quoteViewOriginalCentre.x + point.x, y: quoteViewOriginalCentre.y + point.y)
        
        if sender.state == UIGestureRecognizerState.ended {
            UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.curveLinear, animations: {
                quoteCard?.center = quoteViewOriginalCentre
                generator.impactOccurred()
            }, completion: nil)
        }
    }
    
    func handleTokenSumLabelUpdate() {
        let realm = try! Realm()
        if let currentUser = realm.object(ofType: AimUser.self, forPrimaryKey: Auth.auth().currentUser?.email) {
            let currentTokens = currentUser.tokenPool
            
            ref?.child("users").child((Auth.auth().currentUser?.uid)!).child("Tokens").setValue(currentTokens, withCompletionBlock: { (error, databaseRef) in
                if error != nil {
                    print("Error updating tokens on Firebase: \(error)")
                }
            })
        }
    }
    
    func handleTokenSumReadingFromFirebase() {
        if let userUID = Auth.auth().currentUser?.uid {
            ref?.child("users").child(userUID).child("Tokens").observeSingleEvent(of: .value, with: { (snapshot) in
                if let tokensFetched = snapshot.value as? Float {
                    self.aimTokenSumLabel.text = "\(tokensFetched)"
                } else {
                    print("Could not refresh tokens.")
                }
            })
        }
    }
    
    @IBAction func refreshTokenButtonClicked(_ sender: Any) {
        handleTokenSumReadingFromFirebase()
    }
    
    func awardUserThreeBadge() {
        let fireRef = Database.database().reference()
        fireRef.child("users").child((Auth.auth().currentUser?.uid)!).child("Awards").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild("ThreeDayBadge") == false {
                fireRef.child("users").child((Auth.auth().currentUser?.uid)!).child("Awards").child("ThreeDayBadge").setValue(true)
            }
        })
    }
    
    func awardUserFourBadge() {
        let fireRef = Database.database().reference()
        fireRef.child("users").child((Auth.auth().currentUser?.uid)!).child("Awards").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild("FourDayBadge") == false {
                fireRef.child("users").child((Auth.auth().currentUser?.uid)!).child("Awards").child("FourDayBadge").setValue(true)
            }
        })
    }
    
    func awardUserFiveBadge() {
        let fireRef = Database.database().reference()
        fireRef.child("users").child((Auth.auth().currentUser?.uid)!).child("Awards").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild("FiveDayBadge") == false {
                fireRef.child("users").child((Auth.auth().currentUser?.uid)!).child("Awards").child("FiveDayBadge").setValue(true)
            }
        })
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == toSessionSegueIdentifier {
            let destinationNavigationController = segue.destination as! UINavigationController
            if let destinationViewController = destinationNavigationController.topViewController as? AimSessionViewController, let path = aimSessionCollectionView.indexPathsForSelectedItems?.first {
                self.delegate = destinationViewController
                let sessionObject = aimSessionFetchedArray[path.row]
                destinationViewController.sessionTitleStringValue = sessionObject.title
            }
        }
    }
}
