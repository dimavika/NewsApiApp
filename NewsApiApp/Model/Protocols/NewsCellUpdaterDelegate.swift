//
//  NewsCellUpdaterDelegate.swift
//  NewsApiApp
//
//  Created by Димас on 02.04.2021.
//

import Foundation

protocol NewsCellUpdaterDelegate: class {
    
    func updateCellAfterShowMoreButtonPressed(indexPath: IndexPath, isMore: Bool)
    
}
