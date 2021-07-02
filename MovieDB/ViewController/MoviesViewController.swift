
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

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var moviesInfo: [[MovieInfo]] = []
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let decoder = JSONDecoder()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundView = activityIndicator
        activityIndicator.color = .black
        activityIndicator.startAnimating()
        
        let group = DispatchGroup()
        let apiKey: String = "6c7bcd7c8d501b62b66b43bf32d8c09d"
        
        let urls = [
            "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)",
            "https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)"
        ]
        
        for url in urls {
            guard let url = URL(string: url) else { continue }
            group.enter()
            print("Entrou na url: \(url)")
            DispatchQueue.global().asyncAfter(deadline: .now(), execute: {
                self.request(with: url) { data in
                    guard let data = data,
                          let object = try? decoder.decode(APIModel.self, from: data)
                    else { return }
                    self.moviesInfo.append(object.results)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        group.leave()
                    }
                    
                    print("Saiu na url: \(url)")
                }
            })
        }
        
        group.notify(queue: .main, execute: {
            self.activityIndicator.stopAnimating()
            self.tableView.reloadData()
        })
    }
    
    func request(with url: URL, completion: @escaping (Data?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return completion(nil) }
            completion(data)
        }.resume()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        moviesInfo[section].count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        moviesInfo.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "now-playing-cell", for: indexPath) as? MoviesViewCell else {
            return UITableViewCell()
        }
        let movie = moviesInfo[indexPath.section][indexPath.row]
        cell.setupCell(title: movie.title, description: movie.overview, rating: movie.rating)
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let movie = moviesInfo[indexPath.section][indexPath.row]
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

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Now Playing"
        case 1:
            return "Popular Movies"
        default:
            return nil
        }
    }
}
