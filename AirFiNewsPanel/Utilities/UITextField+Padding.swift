//
//  UITextField+Padding.swift
//  AirFiNewsPanel
//
//  Created by Akash Razdan on 21/07/25.
//

import UIKit

extension UITextField {
    func setLeftPadding(_ points: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: points, height: 0))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
