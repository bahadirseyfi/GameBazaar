//
//  UILabel+Extension.swift
//  GameBazaar
//
//  Created by bahadir on 2.06.2021.
//

import UIKit

extension UILabel {
    func setMargins(_ margin: CGFloat/*CGFloat = 16*/) {
        if let textString = self.text {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.firstLineHeadIndent = margin
            paragraphStyle.headIndent = margin
            paragraphStyle.tailIndent = -margin
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
            attributedText = attributedString
        }
    }
}
