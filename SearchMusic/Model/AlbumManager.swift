//
//  AlbumManager.swift
//  SearchMusic
//
//  Created by Антон on 04.09.2020.
//  Copyright © 2020 Anton Agafonov. All rights reserved.
//

import UIKit


class AlbumManager {
    
    let itunesURL = "https://itunes.apple.com/search?"
    
    var albums = [AlbumModel]()
    
    func fetchAlbum(name: String, closure: @escaping ([AlbumModel]) -> Void) {
        let urlString = "\(itunesURL)term=\(name)&entity=album"
        self.performRequest(with: urlString) { albums in
            closure(albums)
        }
    }
    
    func performRequest(with urlString: String, closure: @escaping ([AlbumModel]) -> Void) {
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print("Could not create a session. \(String(describing: error))")
                    return
                }
                if let safeData = data {
                    if let safeAlbums = self.parseJSON(safeData) {
                        DispatchQueue.main.async {
                            self.albums = safeAlbums
                            closure(self.albums)
                            print(self.albums.count)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ albumData: Data) -> [AlbumModel]? {
        do {
            var array = [AlbumModel]()
            let decodeAlbumData = try JSONDecoder().decode(AlbumData.self, from: albumData)
            
            for item in 0..<decodeAlbumData.resultCount {
                let name = decodeAlbumData.results[item].collectionName
                let image = decodeAlbumData.results[item].artworkUrl100
                let description = decodeAlbumData.results[item].collectionViewUrl
                let albumModel = AlbumModel(albumName: name, albumImage: image, albumDescription: description)
                array.append(albumModel)
            }
            return array
        } catch {
            print("Error decoding data. \(error)")
            return nil
        }
    }
    
    
}
