//
//  AppDetailViewController.swift
//  MyAppStore
//
//  Created by 한아름 on 2021/03/21.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class AppDetailViewController: UIViewController {

    @IBOutlet weak var appIconImageView: UIImageView!
    @IBOutlet weak var appNameLabel: UILabel!
    
    @IBOutlet weak var creatorNameLabel: UILabel!
    @IBOutlet weak var detailCollectionView: UICollectionView!
    @IBOutlet weak var previewCollectionView: UICollectionView!
    
    @IBOutlet weak var formattedPriceLabel: UILabel!
    @IBOutlet weak var rateCountLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionMoreButton: UIButton!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var releaseNoteLabel: UILabel!
    @IBOutlet weak var releaseNoteMoreButton: UIButton!
    
    @IBOutlet weak var providerLabel: UILabel!
    @IBOutlet weak var fileSizeLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var advisoryRatingLabel: UILabel!
    @IBOutlet weak var copyrightLabel: UILabel!
    @IBOutlet weak var previewCollectionHeightConstraint: NSLayoutConstraint!
    
    static func create(with viewModel: AppDetailViewModel) -> AppDetailViewController {
        let vc = AppDetailViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    // MARK: - Life Cycle
    private var viewModel: AppDetailViewModel!
    private var bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        bindUI()
        viewModel.viewDidLoad()
    }
    
    private func registerCell() {
        detailCollectionView.register(UINib(nibName: "AppDetailCollectionViewCell", bundle: nil),
                                forCellWithReuseIdentifier: "AppDetailCollectionViewCell")
        previewCollectionView.register(UINib(nibName: "PreviewCollectionViewCell", bundle: nil),
                                forCellWithReuseIdentifier: "PreviewCollectionViewCell")
    }
    
    private func bindUI() {
        // AppInfo
        viewModel.appInfoSubject.subscribe { [weak self] (event: Event<AppInfoModel>) in
            guard let appInfo = event.element else { return }
            
            // Detail
            self?.appNameLabel.text = appInfo.trackName
            self?.creatorNameLabel.text = appInfo.artistName
            self?.formattedPriceLabel.text = appInfo.formattedPrice ?? ""
            self?.rateCountLabel.text = DisplayUtility.commaNumber(num: appInfo.userRatingCount) + "개의 평가"
            self?.descriptionLabel.text = appInfo.description
            self?.versionLabel.text = "버전 \(appInfo.version)"
            self?.releaseNoteLabel.text = appInfo.releaseNotes
            self?.releaseDateLabel.text = appInfo.releaseDate ?? ""
            self?.providerLabel.text = appInfo.artistName
            self?.fileSizeLabel.text = DisplayUtility.fileSize(byteString: appInfo.fileSizeBytes)
            self?.categoryLabel.text = appInfo.genres?.first ?? ""
            self?.advisoryRatingLabel.text = appInfo.contentAdvisoryRating
            self?.copyrightLabel.text = appInfo.artistName
            
            // App Icon
            self?.appIconImageView.setImage(urlString: appInfo.artworkUrl512 ?? "", placeholder: UIImage(named: "no_image"), bag: self?.bag ?? DisposeBag())
        }.disposed(by: bag)
        
        // Description More Button
        descriptionMoreButton.rx.tap.subscribe { [weak self] (_) in
            self?.descriptionMoreButton.isHidden = true
            self?.descriptionMoreButton.removeConstraints(self?.descriptionMoreButton.constraints ?? [])
            self?.view.layoutIfNeeded()
        }.disposed(by: bag)
        
        // Release Note More Button
        releaseNoteMoreButton.rx.tap.subscribe { [weak self] (_) in
            self?.releaseNoteMoreButton.isHidden = true
            self?.releaseNoteMoreButton.removeConstraints(self?.releaseNoteMoreButton.constraints ?? [])
            self?.view.layoutIfNeeded()
        }.disposed(by: bag)
        
        // Detail Collection Items
        viewModel.detailCollectionItemsSubject.bind(to: detailCollectionView.rx.items(cellIdentifier: "AppDetailCollectionViewCell",
                                                                   cellType: AppDetailCollectionViewCell.self)) {
            (index: Int, model: AppDetailCollectionItemViewModel, cell: AppDetailCollectionViewCell) in
            cell.configure(viewModel: model)
        }.disposed(by: bag)
        
        // Preview Collection Items
        viewModel.previewUrlsSubject.bind(to: previewCollectionView.rx.items(cellIdentifier: "PreviewCollectionViewCell", cellType: PreviewCollectionViewCell.self))  { (indx: Int, previewUrl: String, cell: PreviewCollectionViewCell) in
            cell.configure(previewUrl: previewUrl)
        }.disposed(by: bag)
        
        viewModel.horizontalPreviewMode.subscribe { [weak self] (_) in
            self?.previewCollectionHeightConstraint.constant = 200
        }.disposed(by: bag)
    }
}
