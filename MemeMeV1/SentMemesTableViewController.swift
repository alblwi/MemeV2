//
//  SentMemesTableViewController.swift
//  MemeMeV1
//
//  Created by AHMED ALBLWI on 30/04/2019.
//  Copyright © 2019 AHMED ALBLWI. All rights reserved.
//

import UIKit
class SentMemesTableViewController: UITableViewController {
    let cellID = "cellID"
    var memes: [Meme] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    @IBAction func addNewMeme(_ sender: Any) {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        present(controller, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView.backgroundColor = .green
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! TableCell
        let meme = memes[indexPath.row]
        cell.memeImageView.image = meme.memedImage
        let text = meme.topText + " - " + meme.bottomText
        cell.nameLabel.text = text
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.imageView.image = memes[indexPath.row].memedImage
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return view.frame.size.height / 8.0
        //return 120
    }
}
