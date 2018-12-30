//
//  GenreList.swift
//  MoviesApp
//
//  Created by Pedro Valentini on 25/08/18.
//  Copyright © 2018 Pedro Valentini. All rights reserved.
//

import Foundation

struct GenreList: Decodable {
    
    static var shared: [Genre]? = nil
    
    var genres: [Genre]
    
    static func initWith(data: Data) -> GenreList? {
        do {
            return try JSONDecoder().decode(self, from: data)
        }catch let error {
            print(error)
            return nil
        }
    }
    
}
