//
//  AppSummaryTableViewCell.swift
//  MyAppStore
//
//  Created by 한아름 on 2021/03/21.
//

import UIKit
import RxSwift
import Cosmos

class AppSummaryTableViewCell: UITableViewCell {

    @IBOutlet weak var appIconImageView: UIImageView!
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var kindLabel: UILabel!
    @IBOutlet weak var userRatingCountLabel: UILabel!
    @IBOutlet weak var starView: CosmosView!
    @IBOutlet weak var previewImageView1: UIImageView!
    @IBOutlet weak var previewImageView2: UIImageView!
    @IBOutlet weak var previewImageView3: UIImageView!
    
    private (set) var bag = DisposeBag()
    
    override func prepareForReuse() {
        bag = DisposeBag()
        super.prepareForReuse()
    }
    
    func configure(viewModel: AppSummaryItemViewModel) {
        // Icon Image
        appIconImageView.setImage(urlString: viewModel.iconUrl, placeholder: UIImage(named: "no_image"), bag: bag)
        
        // Preview Images
        let previewImageViewList = [previewImageView1, previewImageView2, previewImageView3]
        previewImageViewList.forEach { $0?.isHidden = true }
        var end = viewModel.screenShotUrls.count > 3 ? 3 : viewModel.screenShotUrls.count
        
        if let size = URL(string: viewModel.screenShotUrls.first ?? "")?
            .lastPathComponent.replacingOccurrences(of: "bb.png", with: "")
            .components(separatedBy: "x"), size.count == 2,
           let width = size.first, let height = size.last, width > height {
            end = 1
        }
        
        for i in 0..<end {
            previewImageViewList[i]?.isHidden = false
            previewImageViewList[i]?.setImage(urlString: viewModel.screenShotUrls[i], placeholder: UIImage(named: "no_image"), bag: bag)
        }
        
        appNameLabel.text = viewModel.appName
        kindLabel.text = viewModel.appKind
        starView.rating = Double(viewModel.averageUserRating)
        userRatingCountLabel.text = DisplayUtility.number(num: viewModel.userRatingCount)
    }
}
