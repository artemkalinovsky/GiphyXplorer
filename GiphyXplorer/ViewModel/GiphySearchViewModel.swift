//
//  GiphySearchViewModel.swift
//  GiphyXplorer
//
//  Created by Artem Kalinovsky on 5/10/19.
//  Copyright © 2019 Artem Kalinovsky. All rights reserved.
//

import RxSwift

struct GiphySearchViewModel {

    private let gifObjectsRepository = GifObjectsRepository()

    func search(query: String,
                rating: GifObject.Rating = .g) -> Observable<[GifObject]> {
        return gifObjectsRepository.searchGifs(query: query,
                                               pagination: GiphyApiServiceRequestPagination(limit: 25, offset: 0),
                                               rating: rating)
    }

}
