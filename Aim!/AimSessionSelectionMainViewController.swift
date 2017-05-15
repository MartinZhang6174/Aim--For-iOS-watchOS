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

let aimApplicationThemeOrangeColor = hexStringToUIColor(hex: "FF4A1C")
let aimApplicationThemePurpleColor = hexStringToUIColor(hex: "1A1423")
let aimApplicationNavBarThemeColor = hexStringToUIColor(hex: "1A1421")

class AimSessionSelectionMainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    let aimApplicationThemeFont24 = UIFont(name: "PhosphatePro-Inline", size: 24)
    
    let toSessionSegueIdentifier = "mainMenuToSessionSegue"
    
    var delegate: AimSessionDurationInfoDelegate?
    var sessionManager = SessionDurationManager()
    
    // CODEREVIEW: Committing code to a Public repository that contains API Keys is a very bad idea.  Consider placing this info inside a constants file that isn't in the repo or using some other way of hiding it.
    let quotesAPIKey = "1fz_Wkqa9BGXusXp1WWkWQeF"
    var quoteCategory = "success"
    var quoteMaxCharRestriction = 120
    
    var togglingLastCell = false
    var selectedCellIndexPath: IndexPath? = nil
    var authorFlipped = false
    
    @IBOutlet var aimSessionCollectionView: UICollectionView!
    @IBOutlet weak var userLoginStatusIndicatorLabel: UILabel!
    @IBOutlet weak var aimTokenSumLabel: UILabel!
    @IBOutlet weak var aimTokenHourSeparaterImageView: UIImageView!
    @IBOutlet weak var aimHourSumLabel: UILabel!
    @IBOutlet weak var uploadProgressView: UIProgressView!
    @IBOutlet var addSessionPopupView: AimSessionAddingPopUpView!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var quoteAuthorLabel: UILabel!
    @IBOutlet weak var quoteView: AimQuoteView!
    
    var sessionObjectArray = [AimSession]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Disable user interaction for now, before a legit quote gets loaded
        self.quoteView.isUserInteractionEnabled = false
        
        let quoteLoadingIndicatorViewFrameRect = CGRect(x: self.view.center.x-25, y: self.quoteLabel.center.y-25, width: 50, height: 50)
        
        let quoteLoadingView = NVActivityIndicatorView(frame: quoteLoadingIndicatorViewFrameRect, type: NVActivityIndicatorType.ballRotate, color: aimApplicationThemeOrangeColor, padding: NVActivityIndicatorView.DEFAULT_PADDING)
        self.moveLoadingView(loadingView: quoteLoadingView)
        
        // getting quote content & author name:
        let quoteFetchingURL = URL(string: "http://quotes.rest/quote/search.json?api_key=\(quotesAPIKey)&category=\(quoteCategory)&maxlength=\(quoteMaxCharRestriction)")!
        let quoteFetchTask = URLSession.shared.dataTask(with: quoteFetchingURL) { (data, response, error) in
            if error != nil {
                print("\(error!.localizedDescription)")
                self.endLoadingView(movingLoadingView: quoteLoadingView)
            } else {
                if let jsonUnformatted = try? JSONSerialization.jsonObject(with: data!, options: []) {
                    let json = jsonUnformatted as? [String: AnyObject]
                    let content = json?["contents"] as? [String: AnyObject]
                    let quoteString = content?["quote"] as? String
                    let quoteAuthorName = content?["author"] as? String
                    
                    if let quote = quoteString {
                        // QUOTE LOADING DONE
                        OperationQueue.main.addOperation {
                            self.quoteView.isUserInteractionEnabled = true
                            self.endLoadingView(movingLoadingView: quoteLoadingView)
                            self.quoteLabel.text = quote
                            if quoteAuthorName != nil {
                                self.quoteAuthorLabel.text = "by  "+quoteAuthorName!
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
        
        // CODEREVIEW: Why is the data being hard-coded in a View Controller?  Consider setting up some kind of data source class for the View Controller.  Any "fake" or testing data can be put into an instance or subclass of that data source.  When you're ready to deploy, you replace that class with the real data source.  Set it up in a way that the View Controller code does not change when you switch from fake data to real data.
        
        // TODO: Change data source to Firebase user data storage.
        // Hard coded data(need to changed data source ASAP):
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
        
        // Set background color: (For some reason I could not match the color I designed in Sketch 3 with the bg color I set in storyboard; therefore, I manually set hex color value onto each UIView element which needs a customized color)
        aimTokenSumLabel.textColor = aimApplicationThemeOrangeColor
        aimTokenHourSeparaterImageView.backgroundColor = aimApplicationThemeOrangeColor
        aimHourSumLabel.textColor = aimApplicationThemeOrangeColor
        
        // Setting navigation bar tint colour to theme purple(for nav bar only)
        self.navigationController?.navigationBar.barTintColor = aimApplicationNavBarThemeColor
        
        let plusObject = AimSession(sessionTitle: "+", dateInitialized: nil, image: nil, priority: false)
        self.sessionObjectArray.append(plusObject)
        
        self.aimSessionCollectionView.isUserInteractionEnabled = true
        
        // Use custom PhosphatePro-Inline font
        aimTokenSumLabel.font = aimApplicationThemeFont24
        aimHourSumLabel.font = aimApplicationThemeFont24
        
        aimSessionCollectionView.alwaysBounceVertical = true
        
        // Check user login status
        if FIRAuth.auth()?.currentUser?.uid == nil {
            perform(#selector(handleLoginRegister), with: nil, afterDelay: 0)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        quoteView.isUserInteractionEnabled = true
        var userLoginStatus = false
        let userLoginEmail = FIRAuth.auth()?.currentUser?.email
        
        FIRAuth.auth()?.currentUser?.uid != nil ? (userLoginStatus = true) : (userLoginStatus = false)
        
        userLoginStatusIndicatorLabel.text = "\(userLoginStatus)\n\(String(describing: userLoginEmail))"
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
            
            sessionCell.sessionInfoLabel.text = "+"
            sessionCell.sessionInfoLabel.font = UIFont(name: "PhosphatePro-Inline", size: 64)
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
        }
        return sessionCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if indexPath.row != sessionObjectArray.count-1 {
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
        
        if indexPath.row == sessionObjectArray.count-1 {
            togglingLastCell = true
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
            
            if togglingLastCell == true {
                quoteView.isUserInteractionEnabled = false
            } else {
                print("I ain't adding no session!")
            }
            
            print("Last item in the collection view has been pressed.")
            animatePopupIn()
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
                print("\(String(describing: error?.localizedDescription))")
            } else {
                print("\(String(describing: metadata))")
            }
        }
        uploadTask.observe(.progress) { [weak self] (snapshot) in
            guard let progress = snapshot.progress else { return }
            self?.uploadProgressView.progress = Float(progress.fractionCompleted)
        }
    }
    
    // To be implemented(or no):
    func uploadMovieToFirebaseStorage(url: URL) {
        
    }
    
    @IBAction func resetProgressButtonPressed(_ sender: Any) {
        self.uploadProgressView.progress = 0.0
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
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == toSessionSegueIdentifier {
            let destinationNavigationController = segue.destination as! UINavigationController
            if let destinationViewController = destinationNavigationController.topViewController as? AimSessionViewController, let path = aimSessionCollectionView.indexPathsForSelectedItems?.first {
                self.delegate = destinationViewController
                let sessionObject = sessionObjectArray[path.row]
                if let existingSessionTitle = sessionObject.title {
                    destinationViewController.sessionTitleStringValue = existingSessionTitle
                } else {
                    destinationViewController.sessionTitleStringValue = "No title"
                }
            }
        }
    }
}
