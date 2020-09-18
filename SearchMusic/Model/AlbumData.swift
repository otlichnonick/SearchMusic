//
//  AlbumData.swift
//  SearchMusic
//
//  Created by Антон on 07.09.2020.
//  Copyright © 2020 Anton Agafonov. All rights reserved.
//

import Foundation

struct AlbumData: Codable {
    let resultCount: Int
    let results: [ResultsAlbum]
}

struct ResultsAlbum: Codable {
    let collectionName: String
    let artworkUrl100: String
    let collectionId: Int
    let artistName: String
    let collectionPrice: Double?
    let trackCount: Int
    let releaseDate: Date?
    let primaryGenreName: String
}

struct SongData: Codable {
    let resultCount: Int
    let results: [ResultSong]
}

struct ResultSong: Codable {
    let trackName: String?
}
