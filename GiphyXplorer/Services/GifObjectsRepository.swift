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

    init() {
        print("Default Realm: \(Realm.Configuration.defaultConfiguration.fileURL?.absoluteString ?? "")")
    }

    func searchGifs(query: String,
                    pagination: GiphyApiServiceRequestPagination,
                    rating: Rating) -> Observable<([GifObject], UInt64)> {
        guard !query.isEmpty else {
            return Observable.just(([GifObject](), 0))
        }

        let giphyApiServiceResponseObservable = giphyApiService.rx
            .request(.searchGifs(query: query, pagination: pagination, rating: rating))
            .map { JSON($0.data) }
            .map { GiphyApiServiceResponse(json: $0) }
            .asObservable().share()

        let realmChangeSetObservable = Observable.changeset(from: realm.objects(GifObject.self))

        giphyApiServiceResponseObservable
            .map { $0.gifObjects }
            .subscribe(Realm.rx.add(update: true, onError: nil))
            .disposed(by: disposeBag)

        return Observable.combineLatest(realmChangeSetObservable, giphyApiServiceResponseObservable)
            .map { (_, giphyApiResponse: GiphyApiServiceResponse) in
                return (giphyApiResponse.gifObjects, giphyApiResponse.pagination.totalCount)
        }
    }
}
