//
//  UILabelExtensions.swift
//  NewsApiApp
//
//  Created by Димас on 02.04.2021.
//

import Foundation
import UIKit

extension UILabel {
    
    func countActualLines() -> Int {
        let myText = self.text! as NSString

        let rect = CGSize(width: self.bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: self.font!], context: nil)

        return Int(ceil(CGFloat(labelSize.height) / self.font.lineHeight))
    }
    
}
