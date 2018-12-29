//
//  MovieAPI.swift
//  MoviesApp
//
//  Created by Pedro Valentini on 25/08/18.
//  Copyright © 2018 Pedro Valentini. All rights reserved.
//

import Foundation
import Moya

enum MovieAPI {
    case upcoming(page: Int)
    case nowPlaying(page: Int)
    case movie(id: Int)
    case genre()
}

extension MovieAPI: TargetType {
    
    var baseURL: URL { return URL(string: "https://api.themoviedb.org/3")! }
   // var apiKey: String { return "1f54bd990f1cdfb230adb312546d765d" }
    var apiKey: String { return "5d408c0ef0d62c93dfb16baf154a0506" }
    
    
    static let smallImagePath = "https://image.tmdb.org/t/p/w185"
    static let bigImagePath = "https://image.tmdb.org/t/p/w342"
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
    var path: String {
        switch self {
        case .upcoming(_):
            return "/movie/upcoming"
            //return "/movie/now_playing"
        case .nowPlaying(_):
            return "/movie/now_playing"
        case .movie(let id):
            return "/movie/\(id)"
        case .genre():
            return "/genre/movie/list"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .upcoming(_), .movie(_), .genre(), .nowPlaying(_):
            return .get
        }
    }
    
    var task: Task {
        var params = ["api_key": apiKey]
        switch self {
        case .upcoming(let page):
            params["page"] = "\(page)"
            break
        case .nowPlaying(let page):
            params["page"] = "\(page)"
            break
        case .movie(_), .genre():
            break
        }
        return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .upcoming(_), .movie(_), .genre(), .nowPlaying(_):
            return URLEncoding.queryString
        }
    }
    
    var sampleData: Data {
        var filename: String
        switch self {
        case .upcoming:
            filename = "upcoming"
            break
        case .nowPlaying:
            filename = "nowPlaying"
            break
        case .movie(_):
            filename = "movie353081"
            break
        case .genre:
            filename = "genre" // TODO
        }
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json"),
            let data = try? Data(contentsOf: url) else {
                return Data()
        }
        return data
    }
    
}
