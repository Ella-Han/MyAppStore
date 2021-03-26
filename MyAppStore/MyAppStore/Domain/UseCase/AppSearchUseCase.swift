//
//  AppSearchUseCase.swift
//  MyAppStore
//
//  Created by 한아름 on 2021/03/21.
//

import Foundation
import RxSwift

protocol AppSearchUseCase {
    func execute(keyword: String) -> Single<[AppInfoModel]>
}

final class DefaultAppSearchUseCase: AppSearchUseCase {
    func execute(keyword: String) -> Single<[AppInfoModel]> {
        return AppStoreManager.requestSearchAppStore(keyword: keyword)
    }
}
