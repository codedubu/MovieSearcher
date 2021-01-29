//
//  MovieError.swift
//  MovieSearch
//
//  Created by River McCaine on 1/29/21.
//

import Foundation

enum MovieError: LocalizedError {
    case invalidURL
    case thrownError(Error)
    case noData
    case unableToDecode
    
} // END OF ENUM

