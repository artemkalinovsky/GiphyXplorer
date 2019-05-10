//
//  GiphySearchViewController.swift
//  GiphyXplorer
//
//  Created by Artem Kalinovsky on 5/10/19.
//  Copyright © 2019 Artem Kalinovsky. All rights reserved.
//

import RxSwift
import RxCocoa

final class GiphySearchViewController: UIViewController {

    private let viewModel = GiphySearchViewModel()
    private let disposeBag = DisposeBag()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        viewModel.search()
            .subscribe { event in
                print("\(event.element ?? [])")
            }
            .disposed(by: disposeBag)
    }

}
