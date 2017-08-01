//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Andrew Ardire on 7/26/17.
//  Copyright © 2017 Andrew F Ardire. All rights reserved.
//

import UIKit

class SentMemesCollectionViewController: UICollectionViewController {
    
    // MARK: Properties
    
    var memes: [Meme] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView?.reloadData()
    }
    
    override func viewDidLoad() {
       super.viewDidLoad()
        
        let space:CGFloat = 2.0
        let xdimension = (self.view.frame.size.width - (2 * space)) / 3.0
        let ydimension = (self.view.frame.size.height - (2*space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: xdimension, height: ydimension)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // TODO: return the # of memes in the model array
        return self.memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //TODO: return a custom cell ; CustomeMemeCell 
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomMemeCell", for: indexPath) as! CustomMemeCell
        let currentMeme = self.memes[(indexPath as NSIndexPath).row]
        
        // Set the properties for the CustomMemeCell
        cell.memeImageView?.image = currentMeme.memedImage
//        cell.memeLabel.text = "\(currentMeme.topText!) ... \(currentMeme.bottomText!)"
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        
        // TODO: When Selected, present the DetailView
        
        // Grab the DetailVC from Storyboard    
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        
        //Populate view controller with data from the selected item
        detailController.meme = self.memes[(indexPath as IndexPath).row]
        
        // Present the view controller using navigation
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }

    
}
