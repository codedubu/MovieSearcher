//
//  MovieListTableViewController.swift
//  MovieSearch
//
//  Created by River McCaine on 1/29/21.
//

import UIKit

class MovieListTableViewController: UITableViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var movieSearchBar: UISearchBar!
    
    // MARK: - Properties
    var movies: [Movie] = []
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        movieSearchBar.delegate = self
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as? MovieTableViewCell else { return UITableViewCell() }
        
        let movie = movies[indexPath.row]
        
        cell.movie = movie
        
        return cell
    }
    
} // END OF CLASS

extension MovieListTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text?.lowercased() else { return }
        
        MovieController.fetchMovies(with: searchTerm) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let movies):
                    self.movies = movies
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
} // END OF EXTENSION
