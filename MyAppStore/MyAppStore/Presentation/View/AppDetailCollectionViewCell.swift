//
//  AppDetailCollectionViewCell.swift
//  MyAppStore
//
//  Created by 한아름 on 2021/03/21.
//

import UIKit
import Cosmos

class AppDetailCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var boldTitleLabel: UILabel!
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var additionalTitleLabel: UILabel!
    @IBOutlet weak var starView: CosmosView!
    @IBOutlet weak var rateView: UIView!
    
    func configure(viewModel: AppDetailCollectionItemViewModel) {
        mainTitleLabel.text = viewModel.mainTitle ?? ""
        boldTitleLabel.text = viewModel.boldTitle ?? ""
        additionalTitleLabel.text = viewModel.additionalTitle ?? ""
        starView.rating = viewModel.starRate ?? 0
        detailImageView.image = viewModel.detailImage
        
        mainTitleLabel.isHidden = viewModel.mainTitle == nil
        boldTitleLabel.isHidden = viewModel.boldTitle == nil
        additionalTitleLabel.isHidden = viewModel.additionalTitle == nil
        detailImageView.isHidden = viewModel.detailImage == nil
        rateView.isHidden = viewModel.starRate == nil
    }
}
