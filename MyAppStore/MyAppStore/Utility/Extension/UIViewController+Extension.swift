//
//  UIViewController+Extension.swift
//  MyAppStore
//
//  Created by 한아름 on 2021/03/20.
//

import Foundation
import UIKit

extension UIViewController {
    func add(child: UIViewController, container: UIView) {
        addChild(child)
        child.view.frame = container.bounds
        container.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func remove() {
        guard parent != nil else { return }
        willMove(toParent: nil)
        removeFromParent()
        view.removeFromSuperview()
    }
}
