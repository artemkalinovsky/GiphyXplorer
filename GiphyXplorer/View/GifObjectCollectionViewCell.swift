//
//  GifObjectCollectionViewCell.swift
//  GiphyXplorer
//
//  Created by Artem Kalinovsky on 5/13/19.
//  Copyright © 2019 Artem Kalinovsky. All rights reserved.
//

import UIKit
import Alamofire
import Nuke
import NukeFLAnimatedImagePlugin
import FLAnimatedImage

final class GifObjectCollectionViewCell: UICollectionViewCell, BaseCellProtocol {
    @IBOutlet private weak var imageView: FLAnimatedImageView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    private var currentGifDataRequest: DataRequest?

    func configure(with gifObject: GifObject) {
        imageView.backgroundColor = GiphyColors.randomColor
        activityIndicator.startAnimating()
        guard let gifUrl = URL(string: gifObject.fixedWidthImage?.urlString ?? "") else { return }
        Nuke.loadImage(with: gifUrl,
                       options: ImageLoadingOptions(transition: .fadeIn(duration: 0.33)),
                       into: imageView,
                       completion: { [weak self] _, _ in
                        self?.activityIndicator.stopAnimating()
                        self?.imageView.backgroundColor = UIColor.clear
        })
    }
}
