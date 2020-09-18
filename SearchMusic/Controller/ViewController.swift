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
    @IBOutlet weak var backgroundImage: UIImageView!
    
    var networkManager = NetworkManager()
    var albumArray: [AlbumModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        searchBar.searchTextField.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        self.dismissKey()
    }
    
}

//MARK: - Search bar delegate methods

extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if searchBar.text != "" {
            let newName = searchBar.text!.replacingOccurrences(of: " ", with: "+")
            networkManager.fetchAlbum(name: newName) { [weak self] in
                self?.albumArray = $0
                self?.collectionView.reloadData()
            }
        }
    }
    
}

//MARK: - Collection view delegate methods

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "SingsViewController") as! SongsViewController
        if let album = albumArray?[indexPath.item] {
            vc.currentAlbum = album
            vc.configure()
            navigationController?.pushViewController(vc, animated: true)
            searchBar.resignFirstResponder()
        }
    }
}

//MARK: - Collection view data source methods

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if albumArray == nil {
            return 0
        } else {
            return albumArray!.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReusableCell", for: indexPath) as! AlbumViewCell
        
        if albumArray?.isEmpty == false {
            cell.imageView.sd_setImage(with: URL(string: self.albumArray?[indexPath.item].albumImage ?? "noimage"))
            cell.nameLabel.text = self.albumArray?[indexPath.item].albumName
            backgroundImage.alpha = 0.3
        }
        return cell
        
    }
}

//MARK: - Dismiss keyboard method

extension UIViewController {
    func dismissKey() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

