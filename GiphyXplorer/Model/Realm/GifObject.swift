//
//  GifObject.swift
//  GiphyXplorer
//
//  Created by Artem Kalinovsky on 5/2/19.
//  Copyright © 2019 Artem Kalinovsky. All rights reserved.
//

import RealmSwift

final class GifObject: Object {
    enum Rating: CaseIterable {
        case y, g, pg, pg13, r

        var apiRequestRepresentation: String {
            switch self {
            case .y:
                return "Y"
            case .g:
                return "G"
            case .pg:
                return "PG"
            case .pg13:
                return "PG-13"
            case .r:
                return "R"
            }
        }
    }

    @objc dynamic var id = ""
    @objc dynamic var ratingRawValue: String?
    @objc dynamic var slug: String?
    @objc dynamic var importDate: Date?
    @objc dynamic var trendingDate: Date?

    @objc dynamic var originalImage: GifImage?
    @objc dynamic var fixedHeightImage: GifImage?
    @objc dynamic var fixedWidthImage: GifImage?

    override static func primaryKey() -> String? {
        return "id"
    }
}
