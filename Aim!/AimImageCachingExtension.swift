//
//  AimImageCachingExtension.swift
//  Aim!
//
//  Created by Martin Zhang on 2017-06-03.
//  Copyright © 2017 Martin Zhang. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func downloadImageUsingCacheWithUrlString(imageURL: String) {
        
        
        // Check if images have already been downloaded:
        if let cachedImage = imageCache.object(forKey: imageURL as AnyObject) as? UIImage {
        
            self.image = cachedImage
            return
        }
        
    
        let url = URL(string: imageURL)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, err) in
            if err != nil {
                print("Error has occured during image fetching: \(String(describing: err))")
                return
            }
            
            // Nothing went wrong, continue constructing session object:
            if let downloadedImage = UIImage(data: data!) {
                DispatchQueue.main.async(execute: {
                    imageCache.setObject(downloadedImage, forKey: imageURL as AnyObject)
                    
                    self.image = downloadedImage
                })
            }
            
            
            
        }).resume()
        
    }
    
    
    
}
