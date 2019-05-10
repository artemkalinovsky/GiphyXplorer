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

    func search() -> Observable<[GifObject]?> {
        return gifObjectsRepository.searchGifs(query: "kitten")
    }
    
}
