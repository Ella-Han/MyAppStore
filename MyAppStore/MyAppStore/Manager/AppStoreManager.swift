//
//  AppStoreManager.swift
//  MyAppStore
//
//  Created by 한아름 on 2021/03/20.
//

import Foundation
import RxSwift
import Defaults

final class AppStoreManager {
    
    static let shared: AppStoreManager = AppStoreManager()
    private (set) var appInfoDict: [String:AppInfoModel]! // bundleId:AppInfoModel
    private (set) var imageCache: NSCache<NSString, UIImage>! // urlString:UIImage
    
    private init() { }
    
    func initialize() {
        appInfoDict = [String:AppInfoModel]()
        imageCache = NSCache<NSString, UIImage>()
    }
    
    func destroy() {
        appInfoDict.removeAll()
        imageCache.removeAllObjects()
    }
    
    //MARK:- Search AppStore
    static func requestSearchAppStore(keyword: String) -> Single<[AppInfoModel]> {
        URLSession.shared.rx
            .json(url: AppStoreAPI.searchAppStore(term: keyword).asURL())
            .asSingle()
            .map { (obj) -> [AppInfoModel] in
                guard let dict = obj as? NSDictionary,
                      let results = dict["results"] as? NSArray else { return [] }
                return AppStoreManager.buildAppInfoList(list: results)
            }
    }
    
    static private func buildAppInfoList(list: NSArray) -> [AppInfoModel] {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: list, options: .prettyPrinted) else { return [] }
        guard let appInfoModels = try? JSONDecoder().decode([AppInfoModel].self, from: jsonData) else { return [] }
        shared.appInfoDict.removeAll()
        appInfoModels.forEach { shared.appInfoDict[$0.bundleId] = $0 }
        return appInfoModels
    }
    
    //MARK:- Image Download
    static func requestDownloadImage(url: URL) -> Single<UIImage?> {
        URLSession.shared.rx
            .data(request: URLRequest(url: url))
            .asSingle()
            .map({ (data: Data) -> UIImage? in
                guard let downloadedImage = UIImage(data: data) else { return nil }
                AppStoreManager.saveToCache(url: url, image: downloadedImage)
                AppStoreManager.saveToDisk(url: url, image: downloadedImage)
                return downloadedImage
            })
    }
    
    static func imageFromCache(url: URL) -> UIImage? {
        return shared.imageCache.object(forKey: (url.absoluteString) as NSString)
    }
    
    static func saveToCache(url: URL, image: UIImage) {
        shared.imageCache.setObject(image, forKey: (url.absoluteString) as NSString)
    }
    
    static func saveToDisk(url: URL, image: UIImage) {
        guard let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else { return }
        let fileName = url.absoluteString.replacingOccurrences(of: "/", with: "_")
        var filePath = URL(fileURLWithPath: path)
        filePath.appendPathComponent(fileName)
    
        if !FileManager.default.fileExists(atPath: filePath.path) {
            FileManager.default.createFile(atPath: filePath.path,
                                           contents: image.jpegData(compressionQuality: 0.4),
                                           attributes: nil)
        }
    }
    
    static func imageFromDisk(url: URL) -> UIImage? {
        guard let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else { return nil }
        let fileName = url.absoluteString.replacingOccurrences(of: "/", with: "_")
        var filePath = URL(fileURLWithPath: path)
        filePath.appendPathComponent(fileName)
        
        if FileManager.default.fileExists(atPath: filePath.path) {
            guard let data = try? Data(contentsOf: filePath) else { return nil }
            return UIImage(data: data)
        }
        return nil
    }
}
