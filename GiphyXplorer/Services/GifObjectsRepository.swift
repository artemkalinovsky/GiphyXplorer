//
// Created by Artem Kalinovsky on 2019-05-06.
// Copyright (c) 2019 Artem Kalinovsky. All rights reserved.
//

import RxSwift
import Realm
import RealmSwift
import RxRealm
import SwiftyJSON
import Moya

struct GifObjectsRepository {

    private let giphyApiService = MoyaProvider<GiphyApiService>()
    private let realm = try! Realm()

    private let disposeBag = DisposeBag()

    func searchGifs(query: String,
                    pagination: GiphyApiServiceRequestPagination,
                    rating: GifObject.Rating) -> Observable<[GifObject]> {
        giphyApiService.rx
            .request(.searchGifs(query: query, pagination: pagination, rating: rating))
            .map { JSON($0.data) }
            .map { GiphyApiServiceResponse(json: $0) }
            .map { $0.gifObjects }
            .asObservable()
            .subscribe(Realm.rx.add(update: true, onError: nil))
            .disposed(by: disposeBag)

        return Observable.changeset(from: realm.objects(GifObject.self)).map { $0.0.toArray() }
    }
}
