//
//  GifImage.swift
//  GiphyXplorer
//
//  Created by Artem Kalinovsky on 5/2/19.
//  Copyright © 2019 Artem Kalinovsky. All rights reserved.
//

import Realm
import RealmSwift
import SwiftyJSON

final class GifImage: Object {
    @objc dynamic var urlString: String?
    @objc dynamic var mp4UrlString: String?
    @objc dynamic var width: Float = 0.0
    @objc dynamic var height: Float = 0.0
    @objc dynamic var data: Data?

    override static func primaryKey() -> String? {
        return "urlString"
    }

    convenience required init(json: JSON) {
        self.init()

        self.urlString = json["url"].string
        self.mp4UrlString = json["mp4"].string
        self.width = json["width"].floatValue
        self.height = json["height"].floatValue
        self.data = nil
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
