//
//  DetailViewController.swift
//  MovieDB
//
//  Created by Nicolas Godoy on 02/07/21.
//

import UIKit

class DetailViewController: UIViewController {

    var movie: MovieInfo?
    //var genres: [Genres] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.dataSource = self
//        tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let movie = movie else { fatalError("no movie found") }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "movie-details") as? MoviesViewCell else { return UITableViewCell() }
        cell.setupCell(title: movie.title, description: movie.overview, rating: movie.rating)
        
        return cell
    }
}
