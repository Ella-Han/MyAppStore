//
//  UIImageView+Extension.swift
//  MyAppStore
//
//  Created by 한아름 on 2021/03/21.
//

import Foundation
import UIKit
import RxSwift

extension UIImageView {
    
    func setImage(urlString: String, placeholder: UIImage? = nil, bag: DisposeBag) {
        guard let url = URL(string: urlString) else { return }
        image = placeholder
        
        // From Memory
        if let cacheImage = AppStoreManager.imageFromCache(url: url) {
            LogI("Image From Memory!!")
            image = cacheImage
            sizeToFit()
            return
        }
        
        // From Disk
        if let diskImage = AppStoreManager.imageFromDisk(url: url) {
            LogI("Image From Disk!!")
            AppStoreManager.saveToCache(url: url, image: diskImage)
            image = diskImage
            sizeToFit()
            return
        }
        
        // Download
        AppStoreManager.requestDownloadImage(url: url)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] (image: UIImage?) in
                LogI("Image From Server!!")
                self?.image = image
                self?.sizeToFit()
            } onFailure: { (error: Error) in
                
            } onDisposed: {
                
            }.disposed(by: bag)
    }
}
