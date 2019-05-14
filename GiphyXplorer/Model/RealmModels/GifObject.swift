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
        if let importDate = json["import_datetime"].string {
            self.importDate = DateFormatters.giphyApiServiceResponseDateFormatter.date(from: importDate)
        }
        if let trendigDate = json["trending_datetime"].string {
            self.trendingDate = DateFormatters.giphyApiServiceResponseDateFormatter.date(from: trendigDate)
        }
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
