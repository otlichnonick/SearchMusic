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
    let results: [Results]
}

struct Results: Codable {
    let collectionName: String
    let collectionViewUrl: String
    let artworkUrl100: String
}
