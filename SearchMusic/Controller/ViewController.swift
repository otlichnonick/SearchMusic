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
    
    
    
}


//MARK: - Search bar delegate methods

extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text != "" {
            albumManager.fetchAlbum(name: searchBar.text!)
        }
    }
    
}

//MARK: - Collection view delegate methods

extension ViewController: UICollectionViewDelegate {
    
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
        
        //cell.imageView.sd_setImage(with: URL(string: self.albumManager.albums[indexPath.item].image ))
        if albumArray?.isEmpty == false {
            cell.imageView.image = self.albumArray?[indexPath.item].image
            cell.nameLabel.text = self.albumArray?[indexPath.item].name
        }
        
        //        print(cell.imageView.image)
        //        print(cell.nameLabel.text)
        return cell
        
    }
    
    
}

