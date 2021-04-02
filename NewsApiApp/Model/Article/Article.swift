//
//  Article.swift
//  NewsApiApp
//
//  Created by Димас on 31.03.2021.
//

import Foundation

// MARK: - ApiContent
struct NewsApiContent: Codable {
    
    let articles: [Article]?
    
}

// MARK: - Article
struct Article: Codable {
    
    let title: String?
    let articleDescription: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
    var isExpanded = false
    
    enum CodingKeys: String, CodingKey {
        case title
        case articleDescription = "description"
        case url, urlToImage, publishedAt, content
    }
    
}
