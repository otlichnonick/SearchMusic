//
//  ViewController.swift
//  SearchMusic
//
//  Created by Антон on 04.09.2020.
//  Copyright © 2020 Anton Agafonov. All rights reserved.
//

import UIKit
import SDWebImage


class ViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var albumManager = AlbumManager()
    var albumArray: [AlbumModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.searchBar.endEditing(true)
    }
    
    @IBAction func tapToHideKeyboard(_ sender: UITapGestureRecognizer) {
        self.searchBar.resignFirstResponder()
    }
    
}


//MARK: - Search bar delegate methods

extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if searchBar.text != "" {
            albumManager.fetchAlbum(name: searchBar.text!) { [weak self] in
                self?.albumArray = $0
                self?.collectionView.reloadData()
                print(self?.albumArray?.count)
            }
        }
    }
    
    
}

//MARK: - Collection view delegate methods

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToSingList", sender: self)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let destinationVC = segue.destination as! SingsViewController
//    }
}

//MARK: - Collection view data source methods

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if albumArray == nil {
            return 1
        } else {
            return albumArray!.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReusableCell", for: indexPath) as! AlbumViewCell
        
        if albumArray?.isEmpty == false {
            cell.imageView.sd_setImage(with: URL(string: self.albumArray?[indexPath.item].albumImage ?? "default_image"))
            cell.nameLabel.text = self.albumArray?[indexPath.item].albumName
        }
        return cell
        
    }
    
    
}

