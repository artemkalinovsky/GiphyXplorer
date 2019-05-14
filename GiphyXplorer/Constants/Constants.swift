//
//  Constants.swift
//  GiphyXplorer
//
//  Created by Artem Kalinovsky on 5/14/19.
//  Copyright © 2019 Artem Kalinovsky. All rights reserved.
//

import Foundation

enum Rating: String {
    case y = "Y"
    case g = "G"
    case pg = "PG"
    case pg13 = "PG-13"
    case r = "R"

    static var allRawCases: [String] {
        return ["Y", "G", "PG", "PG-13", "R"]
    }
}
