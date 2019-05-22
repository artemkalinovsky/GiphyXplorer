//
//  GiphySearchViewModel.swift
//  GiphyXplorer
//
//  Created by Artem Kalinovsky on 5/10/19.
//  Copyright © 2019 Artem Kalinovsky. All rights reserved.
//

import RxSwift

final class GiphySearchViewModel {

    private let gifObjectsRepository = GifObjectsRepository()
    private var pagination = GiphyApiServiceRequestPagination(limit: 25, offset: 0)
    private var isSearchInProgress = false
    private var totalCount: UInt64 = 0

    let gifObjects = Variable<[GifObject]>([GifObject]())

    private let disposeBag = DisposeBag()

    func search(query: String,
                rating: Rating = .g,
                refreshResults: Bool = false) {
        guard !isSearchInProgress else { return }
        isSearchInProgress = true
        pagination = refreshResults ? GiphyApiServiceRequestPagination(limit: 25, offset: 0)
            : GiphyApiServiceRequestPagination(limit: 25, offset: pagination.offset + pagination.limit)

        if pagination.offset > 0 {
            guard pagination.offset + pagination.limit < totalCount else {
                isSearchInProgress = false
                return
            }
        }

        gifObjectsRepository
            .searchGifs(query: query, pagination: pagination, rating: rating)
            .subscribe(onNext: { [unowned self] (gifObjects: [GifObject], totalCount: UInt64) in
                self.totalCount = totalCount
                if refreshResults {
                    self.gifObjects.value = gifObjects
                } else {
                    self.gifObjects.value.append(contentsOf: gifObjects)
                }
                self.isSearchInProgress = false
            }).disposed(by: disposeBag)
    }

}
