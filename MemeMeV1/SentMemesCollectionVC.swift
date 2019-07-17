//
//  SentMemesCollectionVC.swift
//  MemeMeV1
//
//  Created by AHMED ALBLWI on 30/04/2019.
//  Copyright © 2019 AHMED ALBLWI. All rights reserved.
//

import UIKit
class SentMemesCollectionVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    let cellID = "cellID"
    
    @IBAction func addNewMeme(_ sender: Any) {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        present(controller, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    var memes: [Meme] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .orange
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! CollectionCell
        let meme = memes[indexPath.row]
        cell.memeImageView.image = meme.memedImage
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // old code for some check
//        let controller = storyboard?.instantiateViewController(withIdentifier: "Details") as! DetailViewController
//        let meme = memes[indexPath.row]
//        controller.meme = meme
        //--------
//        let item = memes[indexPath.row]
//        performSegue(withIdentifier: "Details", sender: item)
        //--------
        let vc = DetailViewController()
        vc.imageView.image = memes[indexPath.row].memedImage
        navigationController?.pushViewController(vc, animated: true)
       
    }
   
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let width = (screenWidth - 3) / 3
        return CGSize(width: width, height: width)
    }
    
    
    
}
