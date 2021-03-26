//
//  InnerLoadingView.swift
//  MyAppStore
//
//  Created by 한아름 on 2021/03/20.
//

import Foundation
import UIKit

final class InnerLoadingView: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var loadingImageView: UIImageView!
    @IBOutlet weak var loadingLabel: UILabel!
    
    // MARK: Override functions
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadViewFromNib()
        addSubView(view: view)
    }
    
    private func loadViewFromNib() {
        Bundle.main.loadNibNamed("InnerLoadingView", owner: self, options: nil)
        view.frame = bounds
        addSubView(view: view)
    }
    
    public func configure(_ loadingOption: LoadingOption) {
        switch loadingOption {
        case .general(let title):
            loadingLabel.text = title
            loadingImageView.animationImages = [UIImage(named: "loading")!]
        }
        
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = Double.pi*2
        rotation.duration = 2
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        loadingImageView.layer.add(rotation, forKey: "rotationAnimation")
        loadingImageView.startAnimating()
    }
}
