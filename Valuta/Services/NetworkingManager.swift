//
//  NetworkingManager.swift
//  Valuta
//
//  Created by Чистяков Василий Александрович on 18.09.2021.
//

import Foundation

class NetworkingManager {
    
    static var shared = NetworkingManager()
    private init() { }
    
    func fetchRates(complitionHandler: @escaping (RatesModel) -> Void ){
        guard let url = URL(string: "https://www.cbr-xml-daily.ru/daily_json.js") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            print(data)
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let json = try decoder.decode(RatesModel.self, from: data)
                complitionHandler(json)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }.resume()
    }
}
