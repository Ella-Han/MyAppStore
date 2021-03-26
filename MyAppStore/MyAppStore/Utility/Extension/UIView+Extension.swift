//
//  UIView+Extension.swift
//  MyAppStore
//
//  Created by 한아름 on 2021/03/20.
//

import Foundation
import UIKit

extension UIView {
    
    public func addSubView(view: UIView) {
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.autoresizesSubviews = true
        
        addViewWithConstraints(insertView: view, containerView: self)
    }
    
    private func addViewWithConstraints(insertView: UIView, containerView: UIView) {
        containerView.addSubview(insertView)
        
        let top = NSLayoutConstraint(item: insertView, attribute: .top, relatedBy: .equal, toItem: containerView, attribute: .top, multiplier: 1.0, constant: 0)
        let bottom = NSLayoutConstraint(item: insertView, attribute: .bottom, relatedBy: .equal, toItem: containerView, attribute: .bottom, multiplier: 1.0, constant: 0)
        let leading = NSLayoutConstraint(item: insertView, attribute: .leading, relatedBy: .equal, toItem: containerView, attribute: .leading, multiplier: 1.0, constant: 0)
        let trailing = NSLayoutConstraint(item: insertView, attribute: .trailing, relatedBy: .equal, toItem: containerView, attribute: .trailing, multiplier: 1.0, constant: 0)
        
        containerView.addConstraints([top, bottom, leading, trailing])
        containerView.layoutIfNeeded()
    }
}

