//
//  AppDetailViewModel.swift
//  MyAppStore
//
//  Created by 한아름 on 2021/03/21.
//

import Foundation
import RxSwift

struct AppDetailViewModelActions {
    
}

protocol AppDetailViewModelInput {
    func viewDidLoad()
}

protocol AppDetailViewModelOutput {
    var appInfoSubject: PublishSubject<AppInfoModel> { get }
    var isLoadingSubject: PublishSubject<Bool> { get }
    var detailCollectionItemsSubject: BehaviorSubject<[AppDetailCollectionItemViewModel]> { get }
    var previewUrlsSubject: BehaviorSubject<[String]> { get }
    var horizontalPreviewMode: PublishSubject<Bool> { get }
}

protocol AppDetailViewModel: AppDetailViewModelInput, AppDetailViewModelOutput {}

final class DefaultAppDetailViewModel: AppDetailViewModel {

    private let bundleId: String
    private let actions: AppDetailViewModelActions
    private let bag = DisposeBag()
    
    // MARK: - OUTPUT
    let appInfoSubject = PublishSubject<AppInfoModel>()
    let isLoadingSubject = PublishSubject<Bool>()
    let detailCollectionItemsSubject = BehaviorSubject<[AppDetailCollectionItemViewModel]>(value: [])
    let previewUrlsSubject = BehaviorSubject<[String]>(value: [])
    let horizontalPreviewMode = PublishSubject<Bool>()
    
    init(bundleId: String, actions: AppDetailViewModelActions) {
        self.bundleId = bundleId
        self.actions = actions
    }
    
    private func makeAppDetailCollectionItems(appInfo: AppInfoModel) -> [AppDetailCollectionItemViewModel] {
        // 평점
        let starRate = String(format: "%.1f", appInfo.averageUserRating)
        let rateCount = "\(DisplayUtility.number(num: appInfo.userRatingCount))개의 평가"
        let rateItem = AppDetailCollectionItemViewModel(mainTitle: rateCount, boldTitle: starRate, additionalTitle: nil, starRate: Double(starRate) ?? 0, detailImage: nil)
        
        // 평균 연령
        let advisoryItem = AppDetailCollectionItemViewModel(mainTitle: "연령", boldTitle: appInfo.contentAdvisoryRating ?? "", additionalTitle: "세", starRate: nil, detailImage: nil)
        
        // 카테고리
        let categoryItem = AppDetailCollectionItemViewModel(mainTitle: "카테고리", boldTitle: nil, additionalTitle: appInfo.genres?.first ?? "", starRate: nil, detailImage: UIImage(systemName: "pencil.slash"))
        
        // 개발자
        let creatorItem = AppDetailCollectionItemViewModel(mainTitle: "개발자", boldTitle: nil, additionalTitle: appInfo.artistName, starRate: nil, detailImage: UIImage(systemName: "person.crop.square"))
        
        return [rateItem, advisoryItem, categoryItem, creatorItem]
    }
}

extension DefaultAppDetailViewModel {
    func viewDidLoad() {
        guard let appInfo = AppStoreManager.shared.appInfoDict[bundleId]  else { return }
        
        appInfoSubject.onNext(appInfo)
        detailCollectionItemsSubject.onNext(makeAppDetailCollectionItems(appInfo: appInfo))
        previewUrlsSubject.onNext(appInfo.screenshotUrls ?? [])
        
        if let size = URL(string: appInfo.screenshotUrls?.first ?? "")?
            .lastPathComponent.replacingOccurrences(of: "bb.png", with: "")
            .components(separatedBy: "x"), size.count == 2,
           let width = size.first, let height = size.last, width > height {
            horizontalPreviewMode.onNext(true)
        }
    }
}
