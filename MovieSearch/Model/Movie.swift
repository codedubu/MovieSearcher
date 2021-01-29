//
//  Movie.swift
//  MovieSearch
//
//  Created by River McCaine on 1/29/21.
//

import Foundation

struct TopLevelObject: Codable {
    let results: [Movie]
}

struct Movie: Codable {
    let title: String
    let voteAverage: Double
    let overview: String
    let posterPath: String?
    
    enum CodingKeys: String, CodingKey {
        case title
        case voteAverage = "vote_average"
        case overview
        case posterPath = "poster_path"
    }
}
