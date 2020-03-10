//
//  MoviesReponseList.swift
//  MediaList
//
//  Created by  on 05/03/2020.
//  Copyright © 2020 Da Costa Paolo. All rights reserved.
//

import Foundation

struct MediasResponseStruc : Decodable {
       let page : Int?
       let totalResult : Int?
       let media : [MediaResponse]
       
       enum CodingKeys : String, CodingKey {
           case page = "page"
           case totalResult = "total_results"
           case media = "results"
       }
       
       
   }
