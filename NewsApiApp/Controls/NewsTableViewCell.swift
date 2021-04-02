//
//  NewsTableViewCell.swift
//  NewsApiApp
//
//  Created by Димас on 31.03.2021.
//

import UIKit
import Kingfisher

class NewsTableViewCell: UITableViewCell {

    weak var delegate: NewsCellUpdaterDelegate?
    var indexPath: IndexPath?
    
    static let cellId = "ArticleCell"
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var showMoreButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        titleLabel.textColor = Constants.tintColor
        dateLabel.font = UIFont.boldSystemFont(ofSize: 17)
        dateLabel.textColor = .gray
        
        showMoreButton.configure(color: UIColor(.blue),
                                         font: UIFont.boldSystemFont(ofSize: 15),
                                         cornerRadius: showMoreButton.bounds.height / 2,
                                         borderColor: Constants.borderColor,
                                         backgroundColor: .white,
                                         borderWidth: 1.0)
        
        articleImageView.layer.cornerRadius = 10
    }

    @IBAction func showMoreButtonPressed(_ sender: UIButton) {
        if showMoreButton.currentTitle! == "Show more" {
            delegate?.updateCellAfterShowMoreButtonPressed(indexPath: indexPath!, isMore: true)
        } else {
            delegate?.updateCellAfterShowMoreButtonPressed(indexPath: indexPath!, isMore: false)
        }
    }
    
    func configure(article: Article) {
        titleLabel.text = article.title
        descriptionLabel.text = article.articleDescription
        dateLabel.text = String(article.publishedAt?.prefix(10) ?? "No date")
        activityIndicator.startAnimating()
        if article.urlToImage != nil {
            articleImageView.kf.setImage(with: URL(string: article.urlToImage!))
        }
        if articleImageView.image == nil {
            articleImageView.image = UIImage(named: "def-article")
        }
        activityIndicator.stopAnimating()
    }
    
}
