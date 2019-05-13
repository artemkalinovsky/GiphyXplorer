//
//  NibLoadable.swift
//  GiphyXplorer
//
//  Created by Artem Kalinovsky on 5/13/19.
//  Copyright © 2019 Artem Kalinovsky. All rights reserved.
//

import UIKit

protocol NibLoadable {

    associatedtype ViewType = Self
    static func instantiateFromNib() -> ViewType?

}

extension NibLoadable where Self: UIView {

    static func instantiateFromNib() -> ViewType? {
        return Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)?.first as? ViewType
    }

}
