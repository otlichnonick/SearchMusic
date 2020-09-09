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
    
    func fetchAlbum(name: String) {
        let urlString = "\(itunesURL)term=\(name)&entity=album&limit=5"
        performRequest(with: urlString)
        //print(urlString)
    }
    
    func performRequest(with urlString: String) {
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
                        }
                    }
                }
            }
            task.resume()
        }
        print(albums)
    }
    
    func parseJSON(_ albumData: Data) -> [AlbumModel]? {
        do {
            var array = [AlbumModel]()
            let decodeAlbumData = try JSONDecoder().decode(AlbumData.self, from: albumData)
            
            for item in 0..<decodeAlbumData.resultCount {
                let name = decodeAlbumData.results[item].collectionName
                let image = UIImage(named: decodeAlbumData.results[item].artworkUrl100)
                let description = decodeAlbumData.results[item].collectionViewUrl
                let albumModel = AlbumModel(name: name, image: image ?? UIImage(named: "default_image")!, description: description)
                array.append(albumModel)
            }
            return array
        } catch {
            print("Error decoding data. \(error)")
            return nil
        }
    }
    
    
}





//    func performRequest(with urlString: String, completion: @escaping (Data?) -> ()) {
//        let url = URL(string: urlString)
//        let urlRequest = URLRequest(url: url!)
//
//        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
//            if error != nil {
//                print(error.debugDescription)
//            } else {
//                completion(data)
//            }
//        }.resume()
//    }
//
//    func downloadAlbums(from urlString: String, completion: @escaping ([AlbumModel]) -> ()) {
//        performRequest(with: urlString) { (data) in
//            do {
//                let decodeAlbumData = try JSONDecoder().decode(AlbumData.self, from: data!)
//                var array = [AlbumModel]()
//                for item in 0..<decodeAlbumData.resultCount {
//                    let name = decodeAlbumData.results[item].collectionName
//                    let image = UIImage(named: decodeAlbumData.results[item].artworkUrl100)
//                    let description = decodeAlbumData.results[item].collectionViewUrl
//                    let albumModel = AlbumModel(name: name, image: image ?? UIImage(named: "default_image")!, description: description)
//                    array.append(albumModel)
//                }
//                completion(array)
//            } catch {
//                print("Error decoding data. \(error)")
//            }
//        }
//    }
