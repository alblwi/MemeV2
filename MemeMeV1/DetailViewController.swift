//
//  MemeDetailView.swift
//  MemeMeV1
//
//  Created by AHMED ALBLWI on 5/1/19.
//  Copyright © 2019 AHMED ALBLWI. All rights reserved.
//

import Foundation
import UIKit
class DetailViewController:UIViewController{
    
    @IBOutlet weak var memeImage: UIImageView!
    var imageView = UIImageView()
    var meme:Meme!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.addSubview(imageView)
        imageView.frame = view.frame
        imageView.contentMode = .scaleAspectFit
    }
}
