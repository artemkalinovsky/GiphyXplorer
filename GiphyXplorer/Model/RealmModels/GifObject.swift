//
//  GifObject.swift
//  GiphyXplorer
//
//  Created by Artem Kalinovsky on 5/2/19.
//  Copyright © 2019 Artem Kalinovsky. All rights reserved.
//

import Realm
import RealmSwift
import SwiftyJSON

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

    convenience required init(json: JSON) {
        self.init()

        self.id = json["id"].stringValue
        self.ratingRawValue = json["rating"].string
        self.slug = json["slug"].string
        self.importDate = DateFormatters.giphyApiServiceResponseDateFormatter.date(from: json["import_datetime"].stringValue)
        self.trendingDate = DateFormatters.giphyApiServiceResponseDateFormatter.date(from: json["trending_datetime"].stringValue)
        self.originalImage = GifImage(json: json["images"]["original"])
        self.fixedHeightImage = GifImage(json: json["images"]["fixed_height"])
        self.fixedWidthImage = GifImage(json: json["images"]["fixed_width"])
    }

    required init() {
        super.init()
    }

    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }

    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
}
