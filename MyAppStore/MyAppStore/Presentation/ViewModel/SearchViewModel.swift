//
//  SearchViewModel.swift
//  MyAppStore
//
//  Created by 한아름 on 2021/03/21.
//

import Foundation
import RxSwift
import Defaults

struct SearchViewModelActions {
    let showAppDetailView: (_ bundleId: String) -> Void
}

protocol SearchViewModelInput {
    func viewDidLoad()
    func didTapAppItem(bundleId: String)
    func didTapRecentSearchKeyword(keyword: String)
    func didChangeSearchText(keyword: String)
    func didSelectSearchButton(keyword: String)
    func didSelectCancelButton()
}

protocol SearchViewModelOutput {
    var sectionsSubject: BehaviorSubject<[AppSection]> { get }
    var isLoadingSubject: PublishSubject<Bool> { get }
    var noSearchResultSubject: PublishSubject<(isHidden: Bool, keyword: String)> { get }
    var isHiddenRecentSearchTableViewSubject: BehaviorSubject<Bool> { get }
    var recentSearchKeywordSubject: BehaviorSubject<[String]> { get }
    var serverErrorSubject: PublishSubject<String> { get }
}

protocol SearchViewModel: SearchViewModelInput, SearchViewModelOutput {}

final class DefaultSearchViewModel: SearchViewModel {
    private let actions: SearchViewModelActions
    private let appSearchUseCase = DefaultAppSearchUseCase()
    private let bag = DisposeBag()
    
    // MARK: - OUTPUT
    let sectionsSubject = BehaviorSubject<[AppSection]>(value: [])
    let isLoadingSubject = PublishSubject<Bool>()
    let noSearchResultSubject = PublishSubject<(isHidden: Bool, keyword: String)>()
    let isHiddenRecentSearchTableViewSubject = BehaviorSubject<Bool>(value: false)
    let recentSearchKeywordSubject = BehaviorSubject<[String]>(value: [])
    let serverErrorSubject = PublishSubject<String>()
    
    init(actions: SearchViewModelActions) {
        self.actions = actions
    }
    
    private func searchAppStore(keyword: String) {
        isLoadingSubject.onNext(true)
        
        appSearchUseCase.execute(keyword: keyword).subscribe { [weak self] (appInfoModels: [AppInfoModel]) in
            let itemViewModels = appInfoModels.map { AppSummaryItemViewModel(model: $0) }
            let section = AppSection(header: 0, items: itemViewModels)
            
            self?.sectionsSubject.onNext([section])
            self?.noSearchResultSubject.onNext((isHidden: !appInfoModels.isEmpty, keyword: keyword))
            self?.isHiddenRecentSearchTableViewSubject.onNext(true)
            self?.isLoadingSubject.onNext(false)
            
        } onFailure: { [weak self] (error: Error) in
            self?.noSearchResultSubject.onNext((isHidden: false, keyword: keyword))
            self?.serverErrorSubject.onNext(error.localizedDescription)
            self?.isLoadingSubject.onNext(false)
            
        } onDisposed: {
            
        }.disposed(by: bag)
    }
    
    private func switchToRecentSearchView(filteringKeyword: String) {
        var keywords = Defaults[.recentSearchKeywords]
        if !filteringKeyword.isEmpty {
            keywords = Defaults[.recentSearchKeywords]
                .filter { $0.lowercased().contains(filteringKeyword.lowercased()) }
        }
        
        recentSearchKeywordSubject.onNext(keywords)
        isHiddenRecentSearchTableViewSubject.onNext(false)
        noSearchResultSubject.onNext((isHidden: true, keyword: ""))
        sectionsSubject.onNext([])
    }
    
    private func reorderRecentSearchKeywords(keywordAtFirst: String) {
        var recentKeywords = Defaults[.recentSearchKeywords]
        if let idx = recentKeywords.firstIndex(of: keywordAtFirst) { recentKeywords.remove(at: idx) }
        recentKeywords.insert(keywordAtFirst, at: 0)
        Defaults[.recentSearchKeywords] = recentKeywords
    }
}

extension DefaultSearchViewModel {
    func viewDidLoad() {
        switchToRecentSearchView(filteringKeyword: "")
    }
    
    func didTapAppItem(bundleId: String) {
        LogI("bundleId: \(bundleId)")
        actions.showAppDetailView(bundleId)
    }
    
    func didTapRecentSearchKeyword(keyword: String) {
        LogI("keyword: \(keyword)")
        reorderRecentSearchKeywords(keywordAtFirst: keyword)
        searchAppStore(keyword: keyword)
    }
    
    func didSelectSearchButton(keyword: String) {
        LogI("keyword: \(keyword)")
        reorderRecentSearchKeywords(keywordAtFirst: keyword)
        searchAppStore(keyword: keyword)
    }
    
    func didSelectCancelButton() {
        LogI("didSelectCancelButton")
        switchToRecentSearchView(filteringKeyword: "")
    }
    
    func didChangeSearchText(keyword: String) {
        LogI("keyword: \(keyword)")
        switchToRecentSearchView(filteringKeyword: keyword)
    }
}

