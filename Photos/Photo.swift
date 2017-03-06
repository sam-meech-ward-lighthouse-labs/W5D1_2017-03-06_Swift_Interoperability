//
//  Photo.swift
//  Photos
//
//  Created by Sam Meech-Ward on 2017-03-06.
//  Copyright © 2017 Sam Meech-Ward. All rights reserved.
//

import UIKit

class Photo: NSObject {

    let title: String
    let photoURL: URL
    
    var frame: PhotoFrame?
    
    init(title: String, photoURL url: URL) {
        
        self.title = title
        self.photoURL = url
        
        frame = PhotoFrame(color: "", size: "", pattern: nil)
        
        super.init()
    }
    
    convenience init(title: String) {
        
        self.init(title: "", photoURL: URL(string: "")!)
    }
    
}
