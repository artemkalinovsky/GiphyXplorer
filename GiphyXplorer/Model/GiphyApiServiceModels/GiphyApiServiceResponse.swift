//
// Created by Artem Kalinovsky on 2019-05-06.
// Copyright (c) 2019 Artem Kalinovsky. All rights reserved.
//

import SwiftyJSON

struct GiphyApiServiceResponse {
    let gifObjects: [GifObject]
    let pagination: GiphyApiServiceResponsePagination

    init(json: JSON) {
        self.gifObjects = json["data"].array?.map { GifObject(json: $0) } ?? []
        self.pagination = GiphyApiServiceResponsePagination(json: json["pagination"])
    }
}
