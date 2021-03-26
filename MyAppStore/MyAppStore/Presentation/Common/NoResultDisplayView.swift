//
//  NoResultDisplayView.swift
//  MyAppStore
//
//  Created by 한아름 on 2021/03/20.
//

import Foundation
import UIKit

final class NoResultDisplayView: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var keywordLabel: UILabel!
    
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
        Bundle.main.loadNibNamed("NoResultDisplayView", owner: self, options: nil)
        view.frame = bounds
        addSubView(view: view)
    }
    
    public func configure(description: String) {
        keywordLabel.text = description
    }
}
