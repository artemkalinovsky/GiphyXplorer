//
//  GifImage.swift
//  GiphyXplorer
//
//  Created by Artem Kalinovsky on 5/2/19.
//  Copyright © 2019 Artem Kalinovsky. All rights reserved.
//

import RealmSwift

final class GifImage: Object {
    @objc dynamic var urlString: String?
    @objc dynamic var mp4UrlString: String?
    @objc dynamic var width: Float = 0.0
    @objc dynamic var height: Float = 0.0
    @objc dynamic var data: Data?

    override static func primaryKey() -> String? {
        return "urlString"
    }
}
