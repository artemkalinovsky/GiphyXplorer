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

    private let viewModel = GiphySearchViewModel()

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }

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

        searchBar.rx.searchButtonClicked
            .subscribe({ [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)

        let searchParametersObservable = Observable.combineLatest(searchBar.rx.text.orEmpty.debounce(1, scheduler: MainScheduler.instance).distinctUntilChanged(), ratingTextField.rx.text.orEmpty.distinctUntilChanged())

        searchParametersObservable
            .map { (searchText: String, ratingRawValue: String) in
                return (searchText: searchText, rating: Rating(rawValue: ratingRawValue) ?? .g)
            }.do(onNext: { [unowned self] _ in
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                self.hud.show(in: self.view)
            }).flatMap { [unowned self] searchParams -> Observable<[GifObject]> in
                self.viewModel.search(query: searchParams.searchText, rating: searchParams.rating)
                return self.viewModel.gifObjects.asObservable()
            }.do(onNext: { [unowned self] gifObjects in
                self.collectionView.isHidden = gifObjects.isEmpty
                self.collectionView.setContentOffset(.zero, animated: true)
                self.hud.dismiss(animated: true)
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }).bind(to: collectionView.rx.items(cellIdentifier: GifObjectCollectionViewCell.id,
                                                cellType: GifObjectCollectionViewCell.self)) { _, gifObject, cell in
                                                    cell.configure(with: gifObject)
            }.disposed(by: disposeBag)
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

extension GiphySearchViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        return CGFloat(viewModel.gifObjects.value[indexPath.item].fixedWidthImage?.height ?? 0)
    }
}
