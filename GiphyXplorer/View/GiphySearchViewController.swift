//
//  GiphySearchViewController.swift
//  GiphyXplorer
//
//  Created by Artem Kalinovsky on 5/10/19.
//  Copyright © 2019 Artem Kalinovsky. All rights reserved.
//

import UIKit
import JGProgressHUD
import RxSwift
import RxCocoa

final class GiphySearchViewController: UIViewController {
    @IBOutlet private weak var emojiPlaceholderLabel: UILabel!
    @IBOutlet private weak var placeholderView: UIView!
    @IBOutlet private weak var ratingTextField: UITextField!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private var ratingPickerView: UIPickerView!

    private lazy var hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Loading"
        return hud
    }()

    private lazy var errorHud: JGProgressHUD = {
        let errorHud = JGProgressHUD(style: .dark)
        errorHud.indicatorView = JGProgressHUDErrorIndicatorView()
        return errorHud
    }()

    private let viewModel = GiphySearchViewModel()

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }

        bindPickerView()
        bindCollectionView()

        searchBar.rx.searchButtonClicked
            .subscribe({ [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)

        viewModel.errorPublishSubject.subscribe(onNext: { [unowned self] error in
            self.errorHud.textLabel.text = error.message
            self.errorHud.show(in: self.view, animated: true)
            self.errorHud.dismiss(afterDelay: 2, animated: true)
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

    private func bindPickerView() {
        ratingTextField.inputView = ratingPickerView
        ratingTextField.inputAccessoryView = ratingTextField.doneToolbar()
        ratingTextField.text = Rating.g.rawValue

        Observable.just(Rating.allRawCases)
            .bind(to: ratingPickerView.rx.itemTitles) { _, ratigItem in
                return ratigItem
            }
            .disposed(by: disposeBag)

        ratingPickerView.rx.itemSelected
            .map { row, _ in
                return Rating.allRawCases[row]
            }
            .bind(to: ratingTextField.rx.text)
            .disposed(by: disposeBag)
    }

    private func bindCollectionView() {
        let searchBarTextObservable = searchBar.rx.text
            .orEmpty
            .debounce(2, scheduler: MainScheduler.instance)
            .distinctUntilChanged()

        let ratingObservable = ratingTextField.rx.text.orEmpty.distinctUntilChanged()

        Observable.combineLatest(searchBarTextObservable, ratingObservable)
            .map { [unowned self] (searchText: String, ratingRawValue: String) in
                if !searchText.isEmpty {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = true
                    self.hud.show(in: self.view)
                    self.collectionView.isHidden = true
                    self.viewModel.gifObjects.value = []
                    self.collectionView.setContentOffset(.zero, animated: true)
                    self.collectionView.collectionViewLayout.invalidateLayout()
                }
                return (searchText: searchText, rating: Rating(rawValue: ratingRawValue) ?? .g)
            }.subscribe(onNext: { [unowned self] (searchText: String, rating: Rating) in
                self.viewModel.search(query: searchText, rating: rating, refreshResults: true)
            }).disposed(by: disposeBag)

        collectionView.rx
            .reachedBottom(offset: 300)
            .subscribe(onNext: { [unowned self] in
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                self.viewModel.search(query: self.searchBar.text ?? "",
                                      rating: Rating(rawValue: self.ratingTextField.text ?? "") ?? .g)
            }).disposed(by: disposeBag)

        viewModel.gifObjects
            .asDriver()
            .do(onNext: { [unowned self] gifObjects in
                self.collectionView.isHidden = gifObjects.isEmpty
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.hud.dismiss(animated: true)
            }).drive(collectionView.rx.items(cellIdentifier: GifObjectCollectionViewCell.id,
                                             cellType: GifObjectCollectionViewCell.self)) { _, gifObject, cell in
                                                cell.configure(with: gifObject)
            }.disposed(by: disposeBag)
    }
}

extension GiphySearchViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        return CGFloat(viewModel.gifObjects.value[indexPath.item].fixedWidthImage?.height ?? 0)
    }
}
