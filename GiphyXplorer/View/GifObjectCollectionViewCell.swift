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

    override func prepareForReuse() {
        super.prepareForReuse()

        currentGifDataRequest?.cancel()
        currentGifDataRequest = nil
        imageView.animatedImage = nil
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
