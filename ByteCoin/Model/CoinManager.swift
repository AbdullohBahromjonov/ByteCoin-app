//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinMenegerDelegate {
    func didUpdatePrice(price: String, currency: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "C33ED7B8-785A-4C15-9B4E-B6C6A4EC4E6F"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    var delegate: CoinMenegerDelegate?
    
    func getCoinPrice(for currency: String) {
        let coinURL = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        print(coinURL)
        performRequest(coinURL, currency: currency)
        
    }
    
    
    //MARK: - Request
    
    func performRequest(_ coinURL: String, currency: String) {
        
        if let url = URL(string: coinURL) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                
                if let error = error {
                    delegate?.didFailWithError(error: error.localizedDescription as! Error)
                    return
                }
                
                if let safeData = data {
                    if let bitcoinPrice = self.parseJSON(safeData) {
                        let priceString = String(format: "%.2f", bitcoinPrice)
                        self.delegate?.didUpdatePrice(price: priceString, currency: currency)
                    }
                }
                
            }
            task.resume()
        }
    }
    
    //MARK: - ParseJSON
    func parseJSON(_ data: Data) -> Double? {
        
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(CoinData.self, from: data)
            
            let lastPrice = decodedData.rate
            print(lastPrice)
            return lastPrice
        }catch{
            return nil
        }
    }
    
    
}
