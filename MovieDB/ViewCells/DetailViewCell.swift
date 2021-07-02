//
//  DetailViewCell.swift
//  MovieDB
//
//  Created by Nicolas Godoy on 02/07/21.
//

import UIKit

class DetailViewCell: UITableViewCell {

    //MARK: - Outlets
    @IBOutlet weak var movieBanner: UIImageView!
    @IBOutlet weak var titleMovie: UILabel!
    @IBOutlet weak var genresMovie: UILabel!
    @IBOutlet weak var movieRating: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        movieBanner.image = nil
    }

    func setupCell(title: String, description: String, rating: Double) {
        movieBanner.layer.cornerRadius = 8
        titleMovie.text = title
        overviewLabel.text = description
        movieRating.text = "\(rating)"
    }

    func setImage(_ image: UIImage?) {
        movieBanner.image = image
        layoutIfNeeded()
    }

}
