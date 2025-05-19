//
//  GoogleMapManager.swift
//  Startup
//
//  Created by Kenneth Wu on 2024/03/07.
//

import Foundation
import CoreLocation

class GoogleMapManager {
                  static let sharedInstance = GoogleMapManager()
    let api_Key = CommonSettings.googleMapApiKey
    
    func fetchNearLocation(_ location: String, keyWord: String, radius: String, completion: @escaping (Result<[MapInfoResults],Error>) -> Void) {
        if let url = URL(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(location)&radius=\(radius)&keyword=\(keyWord)&language=zh-TW&key=\(api_Key)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") {
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let GoogleMapResponse = try decoder.decode(GoogleMapResponse.self, from: data)
                        completion(.success(GoogleMapResponse.results))
                    }catch{
                        completion(.failure(error))
                    }
                }
            }.resume()
        }
    }
}
