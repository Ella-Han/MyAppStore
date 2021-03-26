//
//  AppDetailCollectionItemViewModel.swift
//  MyAppStore
//
//  Created by 한아름 on 2021/03/21.
//

import Foundation
import UIKit

struct AppDetailCollectionItemViewModel: Equatable {
    let mainTitle: String?
    let boldTitle: String?
    let additionalTitle: String?
    let starRate: Double?
    let detailImage: UIImage?
}
