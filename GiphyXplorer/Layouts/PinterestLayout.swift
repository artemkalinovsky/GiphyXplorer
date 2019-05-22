//
//  PinterestLayout.swift
//  GiphyXplorer
//
//  Created by Artem Kalinovsky on 5/21/19.
//  Copyright © 2019 Artem Kalinovsky. All rights reserved.
//

import UIKit

protocol PinterestLayoutDelegate: class {
    func collectionView(_ collectionView: UICollectionView,
                        heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat
}

final class PinterestLayout: UICollectionViewLayout {
    weak var delegate: PinterestLayoutDelegate?
    
    private var contentHeight: CGFloat = 0
    private var numberOfColumns = 2
    private var cellPadding: CGFloat = 6
    private var cache = [UICollectionViewLayoutAttributes]()

    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }

    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }

    override func prepare() {
        super.prepare()

        cache.removeAll()
        guard let delegate = delegate, cache.isEmpty == true, let collectionView = collectionView else {
            return
        }
        contentHeight = 0
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset = [CGFloat]()
        for column in 0 ..< numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        var column = 0
        var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)

        for item in 0 ..< collectionView.numberOfItems(inSection: 0) {

            let indexPath = IndexPath(item: item, section: 0)

            let photoHeight = delegate.collectionView(collectionView, heightForPhotoAtIndexPath: indexPath)
            let height = cellPadding * 2 + photoHeight
            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)

            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)

            contentHeight = max(contentHeight, frame.maxY)

            yOffset[column] = yOffset[column] + height

            column = column < (numberOfColumns - 1) ? (column + 1) : 0
        }
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cache.filter { $0.frame.intersects(rect) }
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }

}
