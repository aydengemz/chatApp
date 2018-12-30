//
//  TrailerList.swift
//  RainbowiOSSDKSwift
//
//  Created by Ayden Xu on 12/29/18.
//  Copyright © 2018 ALE. All rights reserved.
//

import Foundation

struct TrailerList: Decodable {
    
    static var shared: [Trailer]? = nil
    
    var id: Int
    var results: [Trailer]
    
    
    static func initWith(data: Data) -> TrailerList? {
        do {
            print("@@@inData")
            return try JSONDecoder().decode(self, from: data)
        }catch let error {
            print(error)
            return nil
        }
    }
    
}
