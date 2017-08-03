//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Andrew Ardire on 7/26/17.
//  Copyright © 2017 Andrew F Ardire. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    @IBOutlet weak var detailImageView: UIImageView!
    
    var meme = [Meme]()
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        let currentMeme = meme[0]
        detailImageView.image = currentMeme.memedImage
    }
}
