
import UIKit

struct MovieInfo: CustomStringConvertible {
    let id: Int
    let title: String
    let overview: String
    let rating: Int
    //let image: UIImage
    let genres: [Int]
    
    var description: String {
        return "Movie: \(id)-\(title) - Overview: \(overview)"
    }
}

class MoviesViewController: UIViewController, UITableViewDataSource {
    
    var moviesInfo: [MovieInfo] = []
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        let apiKey: String = "6c7bcd7c8d501b62b66b43bf32d8c09d"
        let urlString = "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)"
        let url = URL(string: urlString)!
        
        typealias NowPlayingMoviesList = [String: Any]
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed),
                  let dictionary = json as? [String: Any],
                  let movies = dictionary["results"] as? [NowPlayingMoviesList]
            else { return  }
            
            var localMovies: [MovieInfo] = []
            
            for movieDictionary in movies {
                guard let id = movieDictionary["id"] as? Int,
                      let title = movieDictionary["title"] as? String,
                      let overview = movieDictionary["overview"] as? String,
                      let rating = movieDictionary["vote_average"] as? Int,
                      //let path = movieDictionary["backdrop_path"] as? String,
                      let genres = movieDictionary["genre_ids"] as? [Int]
                else { continue }
                
                //guard let image = URLRequest.shared.fetchMoviePoster(url: "https://image.tmdb.org/t/p/w500\(path)") else { return }

                
                let movie = MovieInfo(id: id, title: title, overview: overview, rating: rating, genres: genres)
                localMovies.append(movie)
            }
            
            print(localMovies)
            
            self.moviesInfo = localMovies
        }
        .resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "now-playing-cell", for: indexPath)
        
        let movie = moviesInfo[indexPath.row]
        
        cell.textLabel?.text = movie.title
        cell.detailTextLabel?.text = movie.overview
        
        return cell
    }
    
//    public func fetchMoviePoster(with url: URL?) -> UIImage? {
//        guard let url = url, let data = try? Data(contentsOf: url) else { return nil }
//        return UIImage(data: data)
//    }
}


//struct MovieMy: CustomStringConvertible {
//    let id: Int
//    let original_title: String
//    let overview: String
//    //let genre_ids: [String] = []
//    //let poster_path: UIImage
//    let vote_average: String
//
//    var description: String {
//        return "ID/Filme: \(id)-\(original_title), nota: \(vote_average)"
//    }
//}
//
//class MoviesViewController: UIViewController {
//
//    //var movie: [Movie] = []
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        let apiKey: String = "6c7bcd7c8d501b62b66b43bf32d8c09d"
//        let urlString = "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)"
//        let url = URL(string: urlString)!
//
//        //let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=6c7bcd7c8d501b62b66b43bf32d8c09d")!
//
//        URLSession.shared.dataTask(with: url) { (data, response, error) in
//
//            typealias MovieList = [String: Any]
//
//            guard let data = data,
//                  let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed),
//                  let dictionary = json as? [String: Any],
//                  let movies = dictionary["results"] as? [MovieList]
//            else {
//                //completionHandler([])
//                return
//            }
//
//            print(movies)
//
//            var localMovies: [MovieMy] = []
//
//            for movieDictionary in movies {
//                guard let id = movieDictionary["id"] as? Int,
//                      let title = movieDictionary["original_title"] as? String,
//                      let overview = movieDictionary["overview"] as? String,
//                      //let genreIds = movieDictionary["genre_ids"] as? String,
//                      //let movieImage = movieDictionary["poster_path"] as? UIImage,
//                      let voteAverage = movieDictionary["vote_average"] as? String
//                else { continue  }
//
//                let movie = MovieMy(id: id, original_title: title, overview: overview, vote_average: voteAverage)
//                localMovies.append(movie)
//            }
//
//            print(localMovies)
//        }
//        .resume()
//    }
//}
