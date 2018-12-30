//
//  MovieDetailViewController.swift
//  MoviesApp
//
//  Created by Pedro Valentini on 25/08/18.
//  Copyright © 2018 Pedro Valentini. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    var movie: Movie!
    
    let youtubeBaseURL = "https://www.youtube.com/watch?v="
    var trailerId: String!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        
        //trailerId = MovieService.trailerKey(movieId: movie.id, completion: trailerId)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = movie.title
        
        self.titleLabel.text = movie.title
        self.dateLabel.text = movie.release_date
        self.genreLabel.text = movie.genresString
        self.overviewLabel.text = movie.overview
        
        if let imageURL = MovieService.bigCoverUrl(movie: movie) {
            self.coverImageView.load(url: imageURL)
        }
        //print(trailerId + "@@@")
        // TODO: add scrolls
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func playTrailer(_ sender: Any) {
      //  self.performSegue(withIdentifier: "playMovieSegue", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
  
        
            if let destination = segue.destination as? ViewController2 {
                destination.movie = movie
                
              //  print("@@@" + "\(movie.id)")
                //print(trailerId + "@@@segue")
                
                //let videoId = MovieService.trailerId(movieId: movie.id)
                //destination.trailerURL = "https://www.youtube.com/watch?v=" + "\(videoId)"
                
                //print("@@@" + "\(destination.trailerURL)")
                
                //  print("@@@" + "\(movie.id)")
                
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
