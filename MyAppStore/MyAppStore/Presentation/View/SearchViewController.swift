//
//  SearchViewController.swift
//  MyAppStore
//
//  Created by 한아름 on 2021/03/20.
//

import UIKit
import RxCocoa
import RxSwift
import RxGesture
import RxDataSources
import Defaults

class SearchViewController: UIViewController {

    @IBOutlet weak var recentSearchTableView: UITableView!
    @IBOutlet weak var searchResultTableView: UITableView!
    @IBOutlet weak var noResultDisplayView: NoResultDisplayView!
    
    static func create(with viewModel: SearchViewModel) -> SearchViewController {
        let vc = SearchViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    // MARK: - Life Cycle
    private var viewModel: SearchViewModel!
    private var bag = DisposeBag()
    private var dataSource: RxTableViewSectionedAnimatedDataSource<AppSection>?
    private var searchController: UISearchController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        makeDataSource()
        setupView()
        bindUI()
        viewModel.viewDidLoad()
    }
    
    private func setupView() {
        searchController = UISearchController(searchResultsController: nil)
        searchController?.searchResultsUpdater = self
        searchController?.obscuresBackgroundDuringPresentation = false
        
        navigationItem.title = "Search"
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }
    
    private func registerCell() {
        recentSearchTableView.register(UINib(nibName: "RecentSearchTableViewCell", bundle: nil), forCellReuseIdentifier: "RecentSearchTableViewCell")
        searchResultTableView.register(UINib(nibName: "AppSummaryTableViewCell", bundle: nil), forCellReuseIdentifier: "AppSummaryTableViewCell")
    }
    
    private func makeDataSource() {
        dataSource = RxTableViewSectionedAnimatedDataSource<AppSection> (animationConfiguration: AnimationConfiguration(insertAnimation: .none, reloadAnimation: .none, deleteAnimation: .none), configureCell: { [weak self] (dataSource: TableViewSectionedDataSource<AppSection>, tableView: UITableView, indexPath: IndexPath, itemViewModel: TableViewSectionedDataSource<AppSection>.Item) -> UITableViewCell in

            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AppSummaryTableViewCell", for: indexPath) as? AppSummaryTableViewCell else { return UITableViewCell() }
            cell.configure(viewModel: itemViewModel)
            cell.rx.tapGesture().when(.ended).subscribe { [weak self] (event: Event<UITapGestureRecognizer>) in
                self?.viewModel.didTapAppItem(bundleId: itemViewModel.bundleId)
            }.disposed(by: cell.bag)

            return cell
        })
    }
    
    private func bindUI() {
        // SearchBar
        searchController?.searchBar.rx.textDidBeginEditing.subscribe({ [weak self] (_) in
            self?.searchController?.searchBar.showsCancelButton = true
        }).disposed(by: bag)
        
        searchController?.searchBar.rx.textDidEndEditing.subscribe({ [weak self] (_) in
            self?.searchController?.searchBar.showsCancelButton = false
        }).disposed(by: bag)
        
        searchController?.searchBar.rx.searchButtonClicked.subscribe({ [weak self] (_) in
            self?.viewModel.didSelectSearchButton(keyword: self?.searchController?.searchBar.text ?? "")
        }).disposed(by: bag)
        
        searchController?.searchBar.rx.cancelButtonClicked.subscribe({ [weak self] (_) in
            self?.viewModel.didSelectCancelButton()
        }).disposed(by: bag)
        
        // Sections
        viewModel.sectionsSubject
            .bind(to: searchResultTableView.rx.items(dataSource: dataSource!))
            .disposed(by: bag)
        
        // Recent Search TableView
        viewModel.recentSearchKeywordSubject
            .bind(to: recentSearchTableView.rx.items(cellIdentifier: "RecentSearchTableViewCell",
                                                     cellType: RecentSearchTableViewCell.self))
            { (index: Int, element: String, cell: RecentSearchTableViewCell) in
                cell.configure(name: element)
                cell.rx.tapGesture().when(.ended).subscribe { [weak self] (event: Event<UITapGestureRecognizer>) in
                        self?.searchController?.searchBar.text = element
                        self?.viewModel.didTapRecentSearchKeyword(keyword: element)
                }.disposed(by: cell.bag)
                
            }.disposed(by: bag)
        
        // Recent Search TableView (isHidden)
        viewModel.isHiddenRecentSearchTableViewSubject
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] (event: Event<Bool>) in
            guard let isHidden = event.element else { return }
            self?.recentSearchTableView.isHidden = isHidden
        }.disposed(by: bag)
        
        // No Result
        viewModel.noSearchResultSubject
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] (event: Event<(isHidden: Bool, keyword: String)>) in
                guard let info = event.element else { return }
                self?.noResultDisplayView.isHidden = info.isHidden
                self?.noResultDisplayView.configure(description: "for '\(info.keyword)'")
            }.disposed(by: bag)
        
        // Loading
        viewModel.isLoadingSubject
            .observe(on: MainScheduler.instance)
            .subscribe { (event: Event<Bool>) in
            guard let isLoading = event.element else { return }
            if isLoading {
                LoadingView.show(.general(title: "검색 중..."))
            } else {
                LoadingView.hide()
            }
        }.disposed(by: bag)
        
        // Server Error
        viewModel.serverErrorSubject.observe(on: MainScheduler.instance).subscribe { [weak self] (event: Event<String>) in
            guard let errorMsg = event.element else { return }
            let alert = UIAlertController(title: "Error", message: errorMsg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            self?.present(alert, animated: true, completion: nil)
        }.disposed(by: bag)
        
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        viewModel.didChangeSearchText(keyword: searchText)
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text ?? "")
    }
}
