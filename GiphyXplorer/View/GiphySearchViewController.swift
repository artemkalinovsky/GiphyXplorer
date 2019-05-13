//
//  GiphySearchViewController.swift
//  GiphyXplorer
//
//  Created by Artem Kalinovsky on 5/10/19.
//  Copyright © 2019 Artem Kalinovsky. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class GiphySearchViewController: UIViewController {

    @IBOutlet private weak var emojiPlaceholderLabel: UILabel!
    @IBOutlet private weak var placeholderView: UIView!
    @IBOutlet private weak var ratingTextField: UITextField!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private var ratingPickerView: UIPickerView!

    private let viewModel = GiphySearchViewModel()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        ratingTextField.inputView = ratingPickerView
        ratingTextField.inputAccessoryView = ratingTextField.doneToolbar()
        ratingTextField.text = GifObject.Rating.g.rawValue

        Observable.just(GifObject.Rating.allRawCases)
            .bind(to: ratingPickerView.rx.itemTitles) { _, ratigItem in
                return ratigItem
            }
            .disposed(by: disposeBag)

        ratingPickerView.rx.itemSelected
            .map { row, _ in
                return GifObject.Rating.allRawCases[row]
            }
            .bind(to: ratingTextField.rx.text)
            .disposed(by: disposeBag)

        searchBar.rx.searchButtonClicked
            .subscribe({ [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)

        let searchParametersObservable = Observable.combineLatest(searchBar.rx.text.orEmpty.throttle(2, scheduler: MainScheduler.instance).distinctUntilChanged(),
                                                                  ratingTextField.rx.text.orEmpty.distinctUntilChanged()).share()

        searchParametersObservable.filter { searchBarText, _  in
            return searchBarText.isEmpty
            }.subscribe(onNext: { [weak self] _, _ in
                self?.collectionView.isHidden = true
            }).disposed(by: disposeBag)

        searchParametersObservable
            .filter { searchBarText, ratingText in
                return !searchBarText.isEmpty && !ratingText.isEmpty
            }
            .map {
                return (searchText: $0, rating: GifObject.Rating(rawValue: $1) ?? .g)
            }.flatMap {
                self.viewModel.search(query: $0.searchText, rating: $0.rating)
            }.subscribe(onNext: { [weak self] gifObjects in
                self?.collectionView.isHidden = false
                print("\(gifObjects)")
            }).disposed(by: disposeBag)

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        UIView.animate(withDuration: 3,
                       delay: 0,
                       options: [.autoreverse, .repeat, .curveEaseInOut],
                       animations: {
                        self.emojiPlaceholderLabel.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        })
    }

}
