//
//  MainFlowCoordinator.swift
//  MyAppStore
//
//  Created by 한아름 on 2021/03/20.
//

import Foundation
import UIKit

final class MainFlowCoordinator {
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = SearchViewController.create(with: DefaultSearchViewModel(actions: SearchViewModelActions(showAppDetailView: showAppDetailView(bundleId:))))
        navigationController?.pushViewController(vc, animated: false)
    }
    
    func showAppDetailView(bundleId: String) {
        let vc = AppDetailViewController.create(with: DefaultAppDetailViewModel(bundleId: bundleId, actions: AppDetailViewModelActions()))
        navigationController?.pushViewController(vc, animated: true)
    }
}
