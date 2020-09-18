//
//  Model.swift
//  SearchMusic
//
//  Created by Антон on 07.09.2020.
//  Copyright © 2020 Anton Agafonov. All rights reserved.
//

import UIKit

struct AlbumModel: Equatable {
    let albumName: String
    let albumImage: String
    let albumID: Int
    let albumGenre: String
    let albumDataRelease: String
    let albumPrice: Double?
    let songCount: Int
    let artistName: String
}

struct SongModel {
    let songName: String?
}
