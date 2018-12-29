




import UIKit

class MovieListDataSource: NSObject, UITableViewDataSource {
    
    var movieList: MovieList? = nil
    
    func setMovieList(newList: MovieList) {
        if self.movieList == nil {
            self.movieList = newList
        }else{
            self.movieList!.page = newList.page
            self.movieList!.results.append(contentsOf: newList.results)
        }
    }
    
    func canLoadMore(indexPath: IndexPath) -> Bool {
        if let movies = movieList {
            let lastRow = movies.results.count - 1
            if indexPath.row == lastRow && movies.page < movies.total_pages {
                return true
            }
        }
        return false
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movieList?.results.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MovieListCell = tableView.dequeueReusableCell(withIdentifier: "MovieListCell", for: indexPath) as! MovieListCell
        
        if let movie = movieList?.results[indexPath.row] {
            cell.titleLabel.text = movie.title
            cell.dateLabel.text = movie.release_date
            cell.genreLabel.text = movie.genresString
            cell.voteLabel.text = String(movie.vote_average)
            
            cell.coverImageView.image = nil
            if let imageURL = MovieService.smallCoverUrl(movie: movie) {
                cell.coverImageView.load(url: imageURL)
            }
        }
        
        return cell
    }
    
}
