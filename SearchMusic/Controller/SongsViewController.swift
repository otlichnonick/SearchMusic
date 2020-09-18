//
//  SongsViewController.swift
//  SearchMusic
//
//  Created by Антон on 04.09.2020.
//  Copyright © 2020 Anton Agafonov. All rights reserved.
//

import UIKit
import SDWebImage

class SongsViewController: UIViewController {
    
    var currentAlbum: AlbumModel?
    var songs: [SongModel]?
    var indicator = UIActivityIndicatorView()
    let networkManager = NetworkManager()
    
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var albumGenre: UILabel!
    @IBOutlet weak var albumDataRelease: UILabel!
    @IBOutlet weak var albumPrice: UILabel!
    @IBOutlet weak var songCount: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var songsListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        songsListTableView.delegate = self
        songsListTableView.dataSource = self
        
        setupUIelements()
   //     setupIndicator()
    }
    
    //MARK: - Configure VC
    
    func configure() {
        networkManager.fetchSong(id: currentAlbum!.albumID) { [weak self] in
            self?.songs = $0
            self?.songsListTableView.reloadData()
        }
    }
    
    func setupUIelements() {
        albumImage.sd_setImage(with: URL(string: currentAlbum?.albumImage ?? "noimage"), completed: nil)
        albumName.text = currentAlbum?.albumName
        albumGenre.text = currentAlbum?.albumGenre
        albumDataRelease.text = currentAlbum?.albumDataRelease?.description
        albumPrice.text = currentAlbum?.albumPrice?.description
        songCount.text = currentAlbum?.songCount.description
        artistName.text = currentAlbum?.artistName
    }
    
    //MARK: - Indicator Activity
    
    func setupIndicator() {
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        indicator.style = .large
        indicator.center = self.view.center
        indicator.hidesWhenStopped = true
        view.addSubview(indicator)
        indicator.startAnimating()
    }
    
    func showIndicator(show: Bool) {
        if show {
            indicator.startAnimating()
        } else {
            indicator.stopAnimating()
        }
    }
}

extension SongsViewController: UITableViewDelegate {
    
}

extension SongsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "songCell", for: indexPath) as! SongViewCell
        cell.numberLabel.text = String(indexPath.row + 1)
        cell.songLabel.text = songs?[indexPath.row].songName
        return cell
    }
    
    
}
