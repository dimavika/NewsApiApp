//
//  ViewController.swift
//  NewsApiApp
//
//  Created by Димас on 31.03.2021.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: -News
    var news = [Article]()
    var searchedNews = [Article]()
    let newsApiService = ApiService<NewsApiContent>()
    
    //MARK: -Dates for updating news
    let currentDate = Date()
    var dateToRemember = Date()
    let isoDateFormatter = ISO8601DateFormatter()
    
    //MARK: -Flags for handling news updates
    var searching = false
    var loadingMore = false
    var refreshing = false
    
    @IBOutlet weak var searchTextField: TextField!
    @IBOutlet weak var newsTableView: UITableView!
    
    let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newsTableView.delegate = self
        newsTableView.dataSource = self
        newsTableView.refreshControl = refreshControl
        
        searchTextField.configure(color: .black,
                                  font: UIFont.systemFont(ofSize: 16),
                                  cornerRadius: searchTextField.bounds.height / 2,
                                  borderColor: Constants.borderColor,
                                  backgroundColor: .white,
                                  borderWidth: 1.0)
        searchTextField.clipsToBounds = true
        
        self.hideKeyboardWhenTappedAround()
        
        let isoCurrentDate = String(isoDateFormatter.string(from: currentDate).prefix(10))
        fetchData(date: isoCurrentDate)
    }
    
    //MARK: -Searchbar implementation
    @IBAction func searchTextFieldDidChange(_ sender: TextField) {
        searchedNews.removeAll()
        
        if searchTextField.text?.count != 0 {
            for article in news {
                if article.title!.lowercased().contains(searchTextField.text!.lowercased()) {
                    searchedNews.append(article)
                }
            }
            searching = true
        } else {
            searching = false
        }
        
        newsTableView.reloadData()
    }
    
}

//MARK: -News TableView implementation
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searching ? searchedNews.count : news.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.cellId, for: indexPath) as! NewsTableViewCell
        
        cell.delegate = self
        cell.indexPath = indexPath
        
        var article: Article
        if searching {
            article = searchedNews[indexPath.row]
        } else {
            article = news[indexPath.row]
        }
        
        cell.configure(article: article)
        
        if article.isExpanded {
            cell.descriptionLabel.numberOfLines = cell.descriptionLabel.countActualLines()
            cell.showMoreButton.setTitle("Show less", for: .normal)
        } else {
            cell.descriptionLabel.numberOfLines = 3
            cell.showMoreButton.setTitle("Show more", for: .normal)
        }
        
        return cell
    }
    
}

extension ViewController: NewsCellUpdaterDelegate {
    
    //MARK: -Cell updating after "Show more" button pressed
    func updateCellAfterShowMoreButtonPressed(indexPath: IndexPath, isMore: Bool) {
        if isMore {
            if !searching {
                news[indexPath.row].isExpanded = true
            } else {
                searchedNews[indexPath.row].isExpanded = true
            }
        } else {
            if !searching {
                news[indexPath.row].isExpanded = false
            } else {
                searchedNews[indexPath.row].isExpanded = false
            }
        }
        
        newsTableView.reloadRows(at: [indexPath], with: .fade)
    }
    
    //MARK: -Pull-to-refresh implementation
    @objc private func refresh(sender: UIRefreshControl) {
        refreshing = true
        
        dateToRemember = Date()
        let isoCurrentDate = String(isoDateFormatter.string(from: currentDate).prefix(10))
        
        news.removeAll()
        newsTableView.reloadData()
        fetchData(date: isoCurrentDate)
        
        sender.endRefreshing()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.height {
            if !refreshing && !loadingMore && !searching {
                infiniteScrollNewsUpdate()
            }
        }
    }
    
    //MARK: -Infinite scroll implementation(works till 7 days news aren't downloaded)
    func infiniteScrollNewsUpdate() {
        loadingMore = true
        
        let dayAgoDate = Calendar.current.date(byAdding: .day, value: -1, to: dateToRemember)!
        let isoDayAgoDate = String(isoDateFormatter.string(from: dayAgoDate).prefix(10))
        dateToRemember = dayAgoDate
        let differenceInDays = Calendar.current.dateComponents([.day], from: dayAgoDate, to: currentDate).day!
        
        if differenceInDays < 6 {
            fetchData(date: isoDayAgoDate)
        }
    }
    
    //MARK: -Fetching news data
    func fetchData(date: String) {
        let urlStr = Constants.url + "&from=\(date)&to=\(date)"
        guard let url = URL(string: urlStr) else { return }
        
        newsApiService.fetchData(forURL: url) { (result) in
            switch result {
            case .failure( _):
                AlertControllerPresenter.presentAlertController(self, title: Constants.updateNewsErrorTitle, message: Constants.updateNewsErrorMessage)
            case .success(let content):
                self.news.append(contentsOf: content.articles!)
                self.loadingMore = false
                self.refreshing = false
                self.newsTableView.reloadData()
            }
        }
    }
}
