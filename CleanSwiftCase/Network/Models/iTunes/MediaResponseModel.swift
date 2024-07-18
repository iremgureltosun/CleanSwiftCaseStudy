//
//  MediaResponseModel.swift
//  CleanSwiftCase
//
//  Created by Tosun, Irem on 17.07.2024.
//

import Foundation

struct MediaResponseModel: HTTPResponseProtocol {
    typealias HTTPEntityType = MediaResponseModel.Type

    var resultCount: Int = 0
    var results: [Result]?

    enum CodingKeys: String, CodingKey {
        case resultCount, results
    }
}

struct Result: Codable {
    let screenshotUrls: [String]
    let ipadScreenshotUrls: [String]
    let appletvScreenshotUrls: [String] // Changed to [String] assuming URLs as strings
    let artworkUrl60: String
    let artworkUrl512: String
    let artworkUrl100: String
    let artistViewURL: String?
    let isGameCenterEnabled: Bool
    let features: [String]
    let advisories: [String]
    let supportedDevices: [String]
    let kind: String
    let averageUserRatingForCurrentVersion: Double
    let averageUserRating: Double
    let trackCensoredName: String
    let languageCodesISO2A: [String]
    let fileSizeBytes: String
    let formattedPrice: String
    let contentAdvisoryRating: String
    let userRatingCountForCurrentVersion: Int
    let trackViewUrl: String
    let trackContentRating: String
    let currentVersionReleaseDate: String
    let releaseNotes: String?
    let artistId: Int
    let artistName: String
    let genres: [String]
    let price: Double
    let resultDescription: String?
    let primaryGenreName: String
    let primaryGenreId: Int
    let genreIds: [String]
    let releaseDate: String
    let bundleId: String
    let sellerName: String
    let isVppDeviceBasedLicensingEnabled: Bool
    let trackId: Int
    let trackName: String
    let currency: String
    let minimumOsVersion: String
    let version: String
    let wrapperType: String
    let userRatingCount: Int
    let sellerUrl: String?

    enum CodingKeys: String, CodingKey {
        case screenshotUrls
        case ipadScreenshotUrls
        case appletvScreenshotUrls
        case artworkUrl60
        case artworkUrl512
        case artworkUrl100
        case artistViewURL
        case isGameCenterEnabled
        case features
        case advisories
        case supportedDevices
        case kind
        case averageUserRatingForCurrentVersion
        case averageUserRating
        case trackCensoredName
        case languageCodesISO2A
        case fileSizeBytes
        case formattedPrice
        case contentAdvisoryRating
        case userRatingCountForCurrentVersion
        case trackViewUrl
        case trackContentRating
        case currentVersionReleaseDate
        case releaseNotes
        case artistId
        case artistName
        case genres
        case price
        case resultDescription
        case primaryGenreName
        case primaryGenreId
        case genreIds
        case releaseDate
        case bundleId
        case sellerName
        case isVppDeviceBasedLicensingEnabled
        case trackId
        case trackName
        case currency
        case minimumOsVersion
        case version
        case wrapperType
        case userRatingCount
        case sellerUrl
    }
}

enum Explicitness: Codable {
    case cleaned
    case explicit
    case notExplicit
}

enum Country: Codable {
    case usa
}

enum WrapperType: Codable {
    case audiobook
    case track
}

enum FormattedPrice: Codable {
    case free
}

