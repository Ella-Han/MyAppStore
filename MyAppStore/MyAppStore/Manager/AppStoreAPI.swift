//
//  AppStoreAPI.swift
//  MyAppStore
//
//  Created by 한아름 on 2021/03/21.
//

import Foundation

enum AppStoreAPI {
    case searchAppStore(term: String)
    
    static let baseURL = "https://itunes.apple.com/"
    
    func asURL() -> URL {
        switch self {
        case .searchAppStore(let term):
            let urlString = AppStoreAPI.baseURL + "search?term=\(term)&entity=software&country=kr"
            let encodedUrlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? AppStoreAPI.baseURL
            return URL(string: encodedUrlString)!
        }
    }
}
