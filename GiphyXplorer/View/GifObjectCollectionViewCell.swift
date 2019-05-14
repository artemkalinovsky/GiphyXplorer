//
//  GifObjectCollectionViewCell.swift
//  GiphyXplorer
//
//  Created by Artem Kalinovsky on 5/13/19.
//  Copyright © 2019 Artem Kalinovsky. All rights reserved.
//

import UIKit
import Alamofire
import FLAnimatedImage

final class GifObjectCollectionViewCell: UICollectionViewCell, BaseCellProtocol {
    @IBOutlet private weak var imageView: FLAnimatedImageView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    private var currentGifDataRequest: DataRequest?

    private static let backgroundColors = [UIColor(red: 255/255, green: 75/255, blue: 80/255, alpha: 1),
                                           UIColor(red: 255/255, green: 246/255, blue: 61/255, alpha: 1),
                                           UIColor(red: 11/255, green: 255/255, blue: 131/255, alpha: 1),
                                           UIColor(red: 0/255, green: 191/255, blue: 255/255, alpha: 1),
                                           UIColor(red: 134/255, green: 0/255, blue: 255/255, alpha: 1)]

    override func prepareForReuse() {
        super.prepareForReuse()

        currentGifDataRequest?.cancel()
        currentGifDataRequest = nil
        imageView.animatedImage = nil
        imageView.backgroundColor = GifObjectCollectionViewCell.backgroundColors[Int.random(in: 0 ..< GifObjectCollectionViewCell.backgroundColors.count)]
    }

    func configure(with gifObject: GifObject) {
        activityIndicator.startAnimating()
        guard let gifUrlString = gifObject.fixedWidthImage?.urlString else { return }
        currentGifDataRequest = Alamofire.request(gifUrlString).responseData { [weak self] gifDataResponse in
            guard let gifData = gifDataResponse.data else { return }
            self?.imageView.animatedImage = FLAnimatedImage(animatedGIFData: gifData)
            self?.activityIndicator.stopAnimating()
        }
    }
}
