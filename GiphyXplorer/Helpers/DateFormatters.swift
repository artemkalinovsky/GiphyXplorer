//
//  DateFormatters.swift
//  GiphyXplorer
//
//  Created by Artem Kalinovsky on 5/8/19.
//  Copyright © 2019 Artem Kalinovsky. All rights reserved.
//

import Foundation

struct DateFormatters {

    static let giphyApiServiceResponseDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm::ss"
        return dateFormatter
    }()

}
