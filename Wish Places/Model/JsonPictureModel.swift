//
//  JsonPictureModel.swift
//  HobPl
//
//  Created by Никита on 27.09.2020.
//  Copyright © 2020 BmjCstms. All rights reserved.
//

import Foundation

class JsonPicture {
    struct ResponcePicture : Decodable {
        let total, totalHits: Int?
        let hits: [HitsStruct]?
    }
    struct HitsStruct : Decodable {
        let id: Int?
        let pageURL: String?
        let type, tags: String?
        let previewURL: String?
        let previewWidth, previewHeight: Int?
        let webformatURL: String?
        let webformatWidth, webformatHeight: Int?
        let largeImageURL, fullHDURL, imageURL: String?
        let imageWidth, imageHeight, imageSize, views: Int?
        let downloads, favorites, likes, comments: Int?
        let userID: Int?
        let user: String?
        let userImageURL: String?
        
        enum CodingKeys: String, CodingKey {
            case id, pageURL, type, tags, previewURL, previewWidth, previewHeight, webformatURL, webformatWidth, webformatHeight, largeImageURL, fullHDURL, imageURL, imageWidth, imageHeight, imageSize, views, downloads, favorites, likes, comments
            case userID = "user_id"
            case user, userImageURL
        }
    }
}

class JsonDataOfPlaces {
    
    struct AllData: Decodable {
        let data: [Datum]?
        let links: [Link]?
        let metadata: Metadata?
    }

    struct Datum: Decodable {
        let id: Int?
        let wikiDataID, type, city, name: String?
        let country, countryCode, region, regionCode: String?
        let latitude, longitude: Double?

        enum CodingKeys: String, CodingKey {
            case id
            case wikiDataID = "wikiDataId"
            case type, city, name, country, countryCode, region, regionCode, latitude, longitude
        }
    }

    struct Link: Decodable {
        let rel, href: String?
    }

    struct Metadata: Decodable {
        let currentOffset, totalCount: Int?
    }
    
}
