//
//  UIResponder+Extensions.swift
//  GiphyXplorer
//
//  Created by Artem Kalinovsky on 5/10/19.
//  Copyright © 2019 Artem Kalinovsky. All rights reserved.
//

import UIKit

extension UIResponder {

    func doneToolbar(height: CGFloat = 44, target: Any? = nil, action: Selector? = nil) -> UIToolbar {
        let doneToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: height))
        doneToolbar.backgroundColor = UIColor.white
        doneToolbar.barTintColor = UIColor.lightGray
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: target ?? self, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                         target: target ?? self,
                                         action: action ?? #selector(UIResponder.resignFirstResponder))
        doneButton.tintColor = UIColor.black

        doneToolbar.items = [flexibleSpace, doneButton]
        return doneToolbar
    }

}
