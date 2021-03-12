//
//  NetworkService.swift
//  HobPl
//
//  Created by Никита on 27.09.2020.
//  Copyright © 2020 BmjCstms. All rights reserved.
//

import Foundation

class NetworkService {
    //Mark: for images API
    func getPictureURL(name: String, closure: @escaping(([String]?) -> Void)) { // выдает в замыкание массив из ссылок на картинки
        
        var resultResponce : JsonPicture.ResponcePicture?
        let questionName = name.replacingOccurrences(of: " ", with: "&")
        
        guard var urlComp = URLComponents(string: "https://pixabay.com/api/") else {
            closure(nil)
            return
        }
        
        let queryItems = [URLQueryItem(name: "key", value: "17769586-1f6903ef3f49abc0b8fa639d5"),
                          URLQueryItem(name: "q", value: questionName)]
        urlComp.queryItems = queryItems
        guard let urlFinal = urlComp.url else {
            closure(nil)
            return
        }
        
        URLSession.shared.dataTask(with: urlFinal) { (data, response, error) in
            guard let data = data else { return }
            guard error == nil else { return }
            
            do {
                resultResponce = try JSONDecoder().decode(JsonPicture.ResponcePicture.self, from: data)
                guard let countHitsCheck = resultResponce!.hits?.count else { return }
                if countHitsCheck == 0 { return closure(nil) } else {
                    
                    var result: [String] = []
                    
                    for index in 0...(countHitsCheck - 1) {
                        guard let value = resultResponce?.hits?[index].largeImageURL else { return }
                        result.append(value)
                    }
                    closure(result)
                }
            } catch let error { print(error) }
        } .resume()
    }
    //Mark: for Geo API
    func loadDataOfPlaces(closure: @escaping(([String]?) -> Void)) {
        
        var jsonResult = JsonDataOfPlaces.AllData.init(data: [JsonDataOfPlaces.Datum].init(), links: [JsonDataOfPlaces.Link].init(), metadata: JsonDataOfPlaces.Metadata.init(currentOffset: 0, totalCount: 0))
        
        let headers = [
            "x-rapidapi-key": "28ec08e93bmshfeb8821b5d2287ap1cd78ejsn46d4236ef47e",
            "x-rapidapi-host": "wft-geo-db.p.rapidapi.com"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://wft-geo-db.p.rapidapi.com/v1/geo/cities")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            guard let data = data else { return }
            guard error == nil else { return }
            
            do {
                jsonResult = try JSONDecoder().decode(JsonDataOfPlaces.AllData.self, from: data)
                guard let countCities = jsonResult.data?.count else { return }
                if countCities == 0 { return closure(nil) } else {
                    
                    var result: [String] = []
                    
                    for index in 0...(countCities - 1) {
                        var value = JsonDataOfPlaces.Datum.init(id: nil, wikiDataID: nil, type: nil, city: nil, name: nil, country: nil, countryCode: nil, region: nil, regionCode: nil, latitude: nil, longitude: nil)
                        value = (jsonResult.data?[index])!
                        let name = value.name
                        result.append(name ?? "")
                    }
                    closure(result)
                }
            } catch let error { print(error) }
        } .resume()
    }
}
