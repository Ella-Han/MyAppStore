//
//  PreviewCollectionViewCell.swift
//  MyAppStore
//
//  Created by 한아름 on 2021/03/23.
//

import UIKit
import RxSwift

private let bag = DisposeBag()

class PreviewCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var previewImageView: UIImageView!

    func configure(previewUrl: String) {
        previewImageView.setImage(urlString: previewUrl, placeholder: UIImage(named: "no_image"), bag: bag)
    }
}

