//
//  GiphyColors.swift
//  GiphyXplorer
//
//  Created by Artem Kalinovsky on 5/14/19.
//  Copyright © 2019 Artem Kalinovsky. All rights reserved.
//

import UIKit

struct GiphyColors {

    static let allColors = [UIColor(red: 255/255, green: 75/255, blue: 80/255, alpha: 1),
                                           UIColor(red: 255/255, green: 246/255, blue: 61/255, alpha: 1),
                                           UIColor(red: 11/255, green: 255/255, blue: 131/255, alpha: 1),
                                           UIColor(red: 0/255, green: 191/255, blue: 255/255, alpha: 1),
                                           UIColor(red: 134/255, green: 0/255, blue: 255/255, alpha: 1)]

    static var randomColor: UIColor {
        return GiphyColors.allColors[Int.random(in: 0 ..< GiphyColors.allColors.count)]
    }

}
