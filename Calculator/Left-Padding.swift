//
//  Left-Padding.swift
//  Calculator
//
//  Created by Mara Gagiu on 2016-07-10.
//  Copyright © 2016 Mara Gagiu. All rights reserved.
//

import Foundation
import UIKit

class UILabelWithleftPadding :UILabel {
    
    override func drawTextInRect(rect: CGRect) {
        let insets = UIEdgeInsets.init(top: 0, left: 5, bottom: 0, right: 5)
        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, insets))
    }
    
}
