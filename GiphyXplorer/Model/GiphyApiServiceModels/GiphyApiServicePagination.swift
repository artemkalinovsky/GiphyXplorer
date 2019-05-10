//
// Created by Artem Kalinovsky on 2019-05-06.
// Copyright (c) 2019 Artem Kalinovsky. All rights reserved.
//

import SwiftyJSON

class GiphyApiServicePagination {
    let offset: UInt64

    init(offset: UInt64) {
        self.offset = offset
    }
}

final class GiphyApiServiceRequestPagination: GiphyApiServicePagination {
    let limit: UInt64

    init(limit: UInt64, offset: UInt64) {
        self.limit = limit
        super.init(offset: offset)
    }
}

final class GiphyApiServiceResponsePagination: GiphyApiServicePagination {
    let totalCount: UInt64
    let count: UInt64

    init(totalCount: UInt64, count: UInt64, offset: UInt64) {
        self.totalCount = totalCount
        self.count = count
        super.init(offset: offset)
    }

    convenience init(json: JSON) {
        self.init(totalCount: json["total_count"].uInt64Value,
                  count: json["count"].uInt64Value,
                  offset: json["offset"].uInt64Value)
    }
}
