//
//  MovieService.swift
//  MoviesApp
//
//  Created by Pedro Valentini on 25/08/18.
//  Copyright © 2018 Pedro Valentini. All rights reserved.
//

import Foundation
import Moya

class MovieService {
    
    
    static let provider = MoyaProvider<MovieAPI>(plugins: [NetworkLoggerPlugin(verbose: true)])
    
    static func genre(completion: @escaping (GenreList?)->()) {
        provider.request(.genre()) { result in
            switch result {
            case let .success(response):
                let genreList = GenreList.initWith(data: response.data)
                GenreList.shared = genreList?.genres
                completion(genreList)
            case let .failure(error):
                print(error)
            }
        }
    }
    
    static func trailerKey(movieId: Int, completion: @escaping (String?)->()){
      //  print("@@@" + "entered Remote call")
        provider.request(.trailerKey(id: movieId)) { result in
            
            switch result {
            case let .success(response):
                let trailerList = TrailerList.initWith(data: response.data)
                // s = (trailerList?.results?
                let s = (trailerList?.results[0].key)!
                //print("@@@ s is: " + s)
                completion(s)
            case let .failure(error):
                print(error)
                // TODO: error handler callback
                //                completion(nil)
            }
        }
       //print("@@@ s is: " + s + "at reutrn of trailer key")
    
    }
    
    
    static func trailerKey2(movieId: Int) -> String {
        print("@@@" + "entered Remote call")
        var s = ""
        provider.request(.trailerKey(id: movieId)) { result in
            
            switch result {
            case let .success(response):
                let trailerList = TrailerList.initWith(data: response.data)
               // s = (trailerList?.results?
                s = (trailerList?.results[0].key)!
                print("@@@ s is: " + s)
            case let .failure(error):
                print(error)
                // TODO: error handler callback
                //                completion(nil)
            }
            
           
        }
        print("@@@ s is: " + s + "at reutrn of trailer key")
        return s
    }
    
    static func upcoming(page: Int, completion: @escaping (MovieList?)->()) {
        
        provider.request(.upcoming(page: page)) { result in
            
            switch result {
            case let .success(response):
                let movies = MovieList.initWith(data: response.data)
                completion(movies)
            case let .failure(error):
                print(error)
                // TODO: error handler callback
//                completion(nil)
            }
        }
    }
    
    static func nowPlaying(page: Int, completion: @escaping (MovieList?)->()) {
        
        provider.request(.nowPlaying(page: page)) { result in
            
            switch result {
            case let .success(response):
                let movies = MovieList.initWith(data: response.data)
                completion(movies)
            case let .failure(error):
                print(error)
                // TODO: error handler callback
                //                completion(nil)
            }
        }
    }
    
    
    
    static func smallCoverUrl(movie: Movie) -> URL? {
        guard let path = movie.poster_path else{ return nil }
        if let url = URL(string: MovieAPI.smallImagePath + path) {
            return url
        }
        return nil
    }
    
    static func bigCoverUrl(movie: Movie) -> URL? {
        guard let path = movie.poster_path else{ return nil }
        if let url = URL(string: MovieAPI.bigImagePath + path) {
            return url
        }
        return nil
    }
    
    
}
