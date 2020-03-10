//
//  MovieList.swift
//  MediaList
//
//  Created by  on 05/03/2020.
//  Copyright © 2020 Da Costa Paolo. All rights reserved.
//

import Foundation

struct MediaResponse : Decodable {
    
    let idMedia : Int
    let titleMedia : String?
    let descriptionMedia : String?
    let yearMedia : String?
    let imagePosterMedia : String?
    let imageBackdropMedia : String?
    let popularityMedia : Float?
    let tagLineMedia : String?
    let runtimeMedia : Int?
    let arrayMedia : [TabGenre]?
    let trailerMedia : [String:[VideoTrailer]]?

    
    enum CodingKeys : String, CodingKey {
        case idMedia = "id"
        case titleMedia = "title"
        case descriptionMedia = "overview"
        case yearMedia = "release_date"
        case imagePosterMedia = "poster_path"
        case imageBackdropMedia = "backdrop_path"
        case popularityMedia = "popularity"
        case tagLineMedia = "tagline"
        case runtimeMedia = "runtime"
        case arrayMedia = "genres"
        case trailerMedia = "videos"
    }
}
