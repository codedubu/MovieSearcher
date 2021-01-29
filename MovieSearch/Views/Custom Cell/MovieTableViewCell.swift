//
//  MovieTableViewCell.swift
//  MovieSearch
//
//  Created by River McCaine on 1/29/21.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var moviePosterImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieRatingLabel: UILabel!
    @IBOutlet weak var movieOverviewLabel: UILabel!
    
    // MARK: - Properties
    // Landing Pad
    
    var movie: Movie? {
        didSet{
            updateViews()
        }
    }
    
    func updateViews() {
        guard let movie = movie else { return }
        movieTitleLabel.text = movie.title
        movieRatingLabel.text = "Rating: \(movie.voteAverage)"
        movieOverviewLabel.text = movie.overview
        MovieController.fetchPoster(for: movie) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let poster):
                    self.moviePosterImageView.image = poster
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
} // END OF CLASS
