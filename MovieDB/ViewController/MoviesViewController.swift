
import UIKit

struct APIModel: Decodable {
    let results: [MovieInfo]
}

struct MovieInfo: CustomStringConvertible, Decodable {
    let id: Int
    let title: String
    let overview: String
    let rating: Double
    let path: String
    let genres: [Int]
    
    var description: String {
        return "Movie: \(id)-\(title) - Overview: \(overview)"
    }

    var urlString: String {
        "https://image.tmdb.org/t/p/w500\(path)"
    }

    private enum CodingKeys : String, CodingKey {
        case id = "id"
        case title = "title"
        case overview = "overview"
        case rating = "vote_average"
        case genres = "genre_ids"
        case path = "poster_path"
    }
}

struct Genres: Decodable {
    let id: Int
    let name: String
}

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var moviesInfo: [MovieInfo] = []
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let decoder = JSONDecoder()
        tableView.delegate = self
        tableView.dataSource = self
        
//        let group = DispatchGroup()
        let apiKey: String = "6c7bcd7c8d501b62b66b43bf32d8c09d"
        let urlString = "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)"
        let url = URL(string: urlString)!

        request(with: url) { data in
            guard let data = data,
                let object = try? decoder.decode(APIModel.self, from: data)
            else { return }
            self.moviesInfo = object.results
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    func request(with url: URL, completion: @escaping (Data?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return completion(nil) }
            completion(data)
        }.resume()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "now-playing-cell", for: indexPath) as? MoviesViewCell else {
            return UITableViewCell()
        }
        let movie = moviesInfo[indexPath.row]
        cell.setupCell(title: movie.title, description: movie.overview, rating: movie.rating)
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let movie = moviesInfo[indexPath.row]
        guard let url = URL(string: movie.urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                if let movieCell = cell as? MoviesViewCell {
                    movieCell.setImage(UIImage(data: data))
                }
            }
        }.resume()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieDetail = moviesInfo[indexPath.row]
        performSegue(withIdentifier: "movieDetails", sender: movieDetail)
    }

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
