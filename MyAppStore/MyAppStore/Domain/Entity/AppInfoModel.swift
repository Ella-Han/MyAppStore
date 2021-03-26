//
//  AppInfoModel.swift
//  MyAppStore
//
//  Created by 한아름 on 2021/03/21.
//

import Foundation

struct AppInfoModel: Codable {
    let bundleId: String
    let screenshotUrls: [String]?
    let ipadScreenshotUrls: [String]?
    let appletvScreenshotUrls: [String]?
    let artworkUrl60: String?
    let artworkUrl512: String?
    let artworkUrl100: String?
    let artistViewUrl: String?
    let supportedDevices: [String]?
    let advisories: [String]?
    let isGameCenterEnabled: Bool?
    let features: [String]?
    let kind: String
    let minimumOsVersion: String?
    let trackCensoredName: String?
    let fileSizeBytes: String
    let sellerUrl: String?
    let formattedPrice: String?
    let contentAdvisoryRating: String?
    let userRatingCountForCurrentVersion: Int
    let averageUserRating: Float
    let trackName: String
    let releaseDate: String?
    let releaseNotes: String?
    let primaryGenreName: String
    let genreIds: [String]?
    let primaryGenreId: Int?
    let currency: String?
    let description: String?
    let artistId: Int
    let artistName: String
    let genres: [String]?
    let price: Float?
    let version: String
    let wrapperType: String?
    let userRatingCount: Int
}
