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
    var gifObjects = Variable<[GifObject]>([GifObject]())

    private let disposeBag = DisposeBag()
    
    func search(query: String,
                rating: Rating = .g) {
        gifObjectsRepository.searchGifs(query: query,
                                               pagination: GiphyApiServiceRequestPagination(limit: 300, offset: 0),
                                               rating: rating).bind(to: gifObjects).disposed(by: disposeBag)
    }

}
