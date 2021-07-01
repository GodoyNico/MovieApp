
import UIKit

struct Movie: CustomStringConvertible {
    let id: Int
    let original_title: String
    let overview: String
    let genre_ids: [String] = []
    let poster_path: UIImage
    let vote_average: String

    var description: String {
        return "ID/Filme: \(id)-\(original_title), gênero: \(genre_ids), nota: \(vote_average)"
    }
}

class MoviesViewController: UIViewController {
    
    var movie: [Movie] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        let apiKey: String = "6c7bcd7c8d501b62b66b43bf32d8c09d"
        let urlString = "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)"
        let url = URL(string: urlString)!
        
        //let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=6c7bcd7c8d501b62b66b43bf32d8c09d")!
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            typealias Movie = [String: Any]
            
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed),
                  let dictionary = json as? [String: Any],
                  let movies = dictionary["results"] as? [Movie]
            else {
                //completionHandler([])
                return
            }
            
            print(movies)
    
            //var localMovies: [Movie] = []
        }
        .resume()
    }
}
