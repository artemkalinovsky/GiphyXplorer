//
// Created by Artem Kalinovsky on 2019-05-06.
// Copyright (c) 2019 Artem Kalinovsky. All rights reserved.
//

import Moya

enum GiphyApiService {

    struct Constants {
        static let apiKey = "pIUz0DCNFXSO2mGHeNE4dUnUwdJctsXZ"
    }

    case searchGifs(query: String, pagination: GiphyApiServiceRequestPagination, rating: GifObject.Rating)
}

// MARK: - TargetType Protocol Implementation

extension GiphyApiService: TargetType {
    var baseURL: URL { return URL(string: "https://api.giphy.com/v1")! }

    var path: String {
        switch self {
        case .searchGifs(_, _, _):
            return "/search"
        }
    }

    var method: Moya.Method {
        switch self {
        case .searchGifs:
            return .get
        }
    }

    var task: Task {
        switch self {
        case let .searchGifs(query, pagination, rating):
            return .requestParameters(parameters: ["api_key": GiphyApiService.Constants.apiKey, "q": query, "limit": pagination.limit, "offset": pagination.offset, "rating": rating.apiRequestRepresentation], 
                    encoding: URLEncoding.queryString)

        }
    }

    var sampleData: Data {
        switch self {
        case .searchGifs(_, _, _):
            guard let url = Bundle.main.url(forResource: "giphy_search_response_example", withExtension: "json"),
                  let data = try? Data(contentsOf: url) else {
                return Data()
            }
            return data
        }
    }

    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}