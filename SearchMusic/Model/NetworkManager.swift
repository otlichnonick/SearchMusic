//
//  NetworkManager.swift
//  SearchMusic
//
//  Created by Антон on 04.09.2020.
//  Copyright © 2020 Anton Agafonov. All rights reserved.
//

import UIKit

class NetworkManager {
    
    let itunesURL = "https://itunes.apple.com/search?"
    
    var albums = [AlbumModel]()
    var songs = [SongModel]()
    
    func fetchAlbum(name: String, closure: @escaping ([AlbumModel]) -> Void) {
        
        let urlString = "\(itunesURL)media=music&entity=album&attribute=albumTerm&term=\(name)"
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                guard error == nil else { fatalError("Could not create a session. \(String(describing: error))") }
                if let safeData = data {
                    do {
                        var array = [AlbumModel]()
                        let decodeAlbumData = try JSONDecoder().decode(AlbumData.self, from: safeData)
                        for item in 0..<decodeAlbumData.resultCount {
                            let album = decodeAlbumData.results[item]
                            let name = album.collectionName
                            let image = album.artworkUrl100
                            let id = album.collectionId
                            let genre = album.primaryGenreName
                            let newDate = self.convertDateFromWebToApp(date: album.releaseDate)
                            let artist = album.artistName
                            let price = album.collectionPrice
                            let count = album.trackCount
                            let newAlbum = AlbumModel(albumName: name, albumImage: image, albumID: id, albumGenre: genre, albumDataRelease: newDate, albumPrice: price, songCount: count, artistName: artist)
                            array.append(newAlbum)
                        }
                        array.sort { $0.albumName.lowercased() < $1.albumName.lowercased() }
                        DispatchQueue.main.async {
                            self.albums = array
                            closure(self.albums)
                        }
                    } catch {
                        print("Error decoding album data. \(error)")
                    }
                }
            }
            task.resume()
        }
    }
    
    func fetchSong(id: Int, closure: @escaping ([SongModel]) -> Void) {
        
        let urlString = "https://itunes.apple.com/lookup?id=\(id)&entity=song"
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                guard error == nil else { fatalError("Could not create a session. \(String(describing: error))") }
                if let safeData = data {
                    do {
                        var array = [SongModel]()
                        let decodeSongData = try JSONDecoder().decode(SongData.self, from: safeData)
                        for item in 0..<decodeSongData.resultCount {
                            let name = decodeSongData.results[item].trackName
                            let newSong = SongModel(songName: name)
                            if newSong.songName != nil {
                            array.append(newSong)
                            }
                        }
                        DispatchQueue.main.async {
                            self.songs = array
                            closure(self.songs)
                        }
                    } catch {
                        print("Error decoding song data. \(error)")
                    }
                }
            }
            task.resume()
        }
    }
    
    func convertDateFromWebToApp(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: date!)
    }
    
}
