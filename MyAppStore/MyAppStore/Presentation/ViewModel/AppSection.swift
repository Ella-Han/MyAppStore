//
//  AppSection.swift
//  MyAppStore
//
//  Created by 한아름 on 2021/03/21.
//

import Foundation
import RxDataSources

struct AppSection {
    var header: Int
    var items: [Item]
}

extension AppSection: AnimatableSectionModelType {
    typealias Item = AppSummaryItemViewModel
    var identity: Int { header }
    
    init(original: AppSection, items: [Item]) {
        self = original
        self.items = items
    }
}

struct AppSummaryItemViewModel: Equatable, IdentifiableType {
    let bundleId: String
    let appName: String
    let appKind: String
    let rating: String
    let averageUserRating: Float
    let userRatingCount: Int
    let iconUrl: String
    let screenShotUrls: [String]
    
    typealias Identity = String
    var identity: String { return bundleId }
    
    init(model: AppInfoModel) {
        bundleId = model.bundleId
        appName = model.trackName
        appKind = model.primaryGenreName
        rating = model.contentAdvisoryRating ?? ""
        averageUserRating = model.averageUserRating
        userRatingCount = model.userRatingCount
        screenShotUrls = model.screenshotUrls ?? []
        iconUrl = model.artworkUrl512 ?? ""
    }
}
