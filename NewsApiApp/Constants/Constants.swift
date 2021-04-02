//
//  Constants.swift
//  NewsApiApp
//
//  Created by Димас on 31.03.2021.
//

import Foundation
import UIKit

struct Constants {
    
    //MARK: -Colors
    static let borderColor: UIColor = UIColor(red: 220.0/255.0, green: 221.0/255.0, blue: 229.0/255.0, alpha: 1.0)
    static let tintColor = UIColor(red: 237.0/255.0, green: 101.0/255.0, blue: 106.0/255.0, alpha: 1.0)
    
    //MARK: -URL
    static let url = "https://newsapi.org/v2/everything?q=apple&language=en&sortBy=popularity&apiKey=6ca6b4975a384c0495d5ec6863d59c12"
    
    //MARK: -Error messages
    static let updateNewsErrorTitle = "Failed to update news"
    static let updateNewsErrorMessage = "Sorry, failed to retrive fresh data. Please, try again later."
    
}
