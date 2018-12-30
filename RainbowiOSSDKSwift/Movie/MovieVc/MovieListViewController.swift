//
//  MovieListViewController.swift
//  MoviesApp
//
//  Created by Pedro Valentini on 25/08/18.
//  Copyright © 2018 Pedro Valentini. All rights reserved.
//

import UIKit

class MovieListViewController: UITableViewController {
    
    var currentPage = 0
    var isLoading = false
    var movieListDataSource = MovieListDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self.movieListDataSource
        self.tableView.register(UINib(nibName: "MovieListCell", bundle: nil), forCellReuseIdentifier: "MovieListCell")
//        self.tableView.register(UINib(nibName: "LoadingCell", bundle: nil), forCellReuseIdentifier: "LoadingCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if GenreList.shared == nil {
            self.loadGenre()
        }else{
            if self.movieListDataSource.movieList == nil {
                self.loadDataFromPage(page: 1)
            }
        }
    /*
        if self.navigationController == nil {
            print("failed")
            return
        }
        
        let navView = UIView()
        
        let label = UILabel()
        label.text = "Movies Currently Playing"
        label.sizeToFit()
        label.center = navView.center
        label.textAlignment = NSTextAlignment.center
        navView.addSubview(label)
        self.navigationItem.titleView = navView
        navView.sizeToFit()
        */
        // TODO: add loading view
        // TODO: error handler and alerts / retry
    }
    
    func loadGenre() {
        MovieService.genre { (genreList) in
            print("Genre List Loaded ", genreList?.genres.count as Any)
            self.loadDataFromPage(page: 1)
            // TODO: add callback for error!!!
        }
    }
    
    func loadDataFromPage(page: Int) {
        if self.isLoading { return }
        self.isLoading = true
        
        print("loadDataFromPage ", self.currentPage)
        
       // MovieService.upcoming(page: page) { movieList in
        MovieService.nowPlaying(page: page) { movieList in
            debugPrint("Movies Page Loaded ", movieList?.page ?? 0)
            
            if movieList != nil {
                self.movieListDataSource.setMovieList(newList: movieList!)
            }
            
            self.tableView.reloadData()
            self.currentPage = page
            self.isLoading = false
            // TODO: add callback for error!!!
        }
    }
    
    // MARK: - UITableViewDelegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "movieDetailSegue", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if movieListDataSource.canLoadMore(indexPath: indexPath) {
            self.loadDataFromPage(page: self.currentPage + 1)
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let index = self.tableView.indexPathForSelectedRow?.row,
            let movie = self.movieListDataSource.movieList?.results[index]
        {
            if let destination = segue.destination as? MovieDetailViewController {
                destination.movie = movie
                
                print("@@@" + "\(movie.id)")
               
                
                //let videoId = MovieService.trailerId(movieId: movie.id)
                //destination.trailerURL = "https://www.youtube.com/watch?v=" + "\(videoId)"
                
                //print("@@@" + "\(destination.trailerURL)")
                
              //  print("@@@" + "\(movie.id)")
                
               
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
   
    
}

