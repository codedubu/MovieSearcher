//
//  MovieController.swift
//  MovieSearch
//
//  Created by River McCaine on 1/29/21.
//

import UIKit

class MovieController {
    // https://api.themoviedb.org/3/search/movie?query=Avengers&api_key=993dc4b0c6ed53e63bfd604ec3a39eca
    
    static let baseURL = URL(string: "https://api.themoviedb.org/")
    static let imageBaseURL = URL(string: "https://image.tmdb.org/t/p/w500/")
    static let versionComponent = "3"
    static let searchComponent = "search"
    static let movieComponent = "movie"
    static let movieQuery = "query"
    static let apiKeyString = "api_key"
    static let apiKeyValue = "993dc4b0c6ed53e63bfd604ec3a39eca"
    
    
    static func fetchMovies(with searchTerm: String, completion: @escaping(Result<[Movie], MovieError>) -> Void ) {
        
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL)) }
        // https://api.themoviedb.org/
        let versionURL = baseURL.appendingPathComponent(versionComponent)
        // https://api.themoviedb.org/3/
        let searchURL = versionURL.appendingPathComponent(searchComponent)
        // https://api.themoviedb.org/3/search/
        let movieURL = searchURL.appendingPathComponent(movieComponent)
        // https://api.themoviedb.org/3/search/movie
        
        var movieURLComponents = URLComponents(url: movieURL, resolvingAgainstBaseURL: true)
        let movieSearchQuery = URLQueryItem(name: movieQuery, value: searchTerm)
        let apiKeyQuery = URLQueryItem(name: apiKeyString, value: apiKeyValue)
        movieURLComponents?.queryItems = [movieSearchQuery, apiKeyQuery]
        
        guard let finalURL = movieURLComponents?.url else { return completion(.failure(.invalidURL)) }
        print(finalURL)
        // https://api.themoviedb.org/3/search/movie?query={searchTerm}&api_key=993dc4b0c6ed53e63bfd604ec3a39eca
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                print("""
                        ("========= ERROR =========")
                        ("Function: \(#function)")
                        ("Error: \(error)")
                        ("Description: \(error.localizedDescription)")
                        ("========= ERROR =========")
                    """)
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else { return completion(.failure(.noData)) }
            do {
                let movieObject = try JSONDecoder().decode(TopLevelObject.self, from: data)
//                var movies: [Movie] = []
//
//                for object in movieObject.results {
//                    let movie = object
//
//                    movies.append(movie)
//                }
                return completion(.success(movieObject.results))
                
            } catch {
                    print("""
                        ("========= ERROR =========")
                        ("Function: \(#function)")
                        ("Error: \(error)")
                        ("Description: \(error.localizedDescription)")
                        ("========= ERROR =========")
                    """)
                return completion(.failure(.unableToDecode))
            }
        }.resume()
    }
    
    static func fetchPoster(for movie: Movie, completion: @escaping(Result<UIImage,MovieError>) -> Void) {
        
        guard let imageBaseURL = imageBaseURL else { return completion(.failure(.invalidURL)) }
        guard let pathStrings = movie.posterPath else { return }
        
        let finalURL = imageBaseURL.appendingPathComponent(pathStrings)
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                print("""
                        ("========= ERROR =========")
                        ("Function: \(#function)")
                        ("Error: \(error)")
                        ("Description: \(error.localizedDescription)")
                        ("========= ERROR =========")
                    """)
                
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data  else { return }
            completion(.failure(.noData))
            
            guard let poster = UIImage(data: data) else { return completion(.failure(.unableToDecode)) }
            
            return completion(.success(poster))
            
        }.resume()
    }
    
} // END OF CLASS
