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
        
        let urlString = "\(itunesURL)media=music&entity=album&attribute=albumTerm&term=\(name)"
        self.performRequest(with: urlString) { albums in
            closure(albums)
        }
    }
    
    func performRequest(with urlString: String, closure: @escaping ([AlbumModel]) -> Void) {
        
        //create URL with name fron searchBar
        if let url = URL(string: urlString) {
            
            //create URLSession as like browser on Mac
            let session = URLSession(configuration: .default)
            
            //give the session a task
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
                        }
                    }
                }
            }
            //start a task
            task.resume()
        }
    }
    
    //get array of albums from Data
    func parseJSON(_ albumData: Data) -> [AlbumModel]? {
        do {
            var array = [AlbumModel]()
            let decodeAlbumData = try JSONDecoder().decode(AlbumData.self, from: albumData)
            
            for item in 0..<decodeAlbumData.resultCount {
                let name = decodeAlbumData.results[item].collectionName
                let image = decodeAlbumData.results[item].artworkUrl100
                let description = decodeAlbumData.results[item].collectionViewUrl
                let id = decodeAlbumData.results[item].collectionId
                let albumModel = AlbumModel(albumName: name, albumImage: image, albumDescription: description, albumID: id)
                array.append(albumModel)
                array.sort { $0.albumName.lowercased() < $1.albumName.lowercased() }
            }
            return array
        } catch {
            print("Error decoding data. \(error)")
            return nil
        }
    }
}
