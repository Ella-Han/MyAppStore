//
//  RecentSearchTableViewCell.swift
//  MyAppStore
//
//  Created by 한아름 on 2021/03/21.
//

import UIKit
import RxSwift

class RecentSearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    private (set) var bag = DisposeBag()
    
    override func prepareForReuse() {
        bag = DisposeBag()
        super.prepareForReuse()
    }
    
    func configure(name: String) {
        nameLabel.text = name
    }
}
