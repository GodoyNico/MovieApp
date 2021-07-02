
import UIKit

class MoviesViewCell: UITableViewCell {

    //MARK: - Outlets
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        movieImage.image = nil
    }

    func setupCell(title: String, description: String, rating: Double) {
        movieImage.layer.cornerRadius = 8
        titleLabel.text = title
        overviewLabel.text = description
        ratingLabel.text = "* \(rating)"
    }

    func setImage(_ image: UIImage?) {
        movieImage.image = image
        layoutIfNeeded()
    }
}
