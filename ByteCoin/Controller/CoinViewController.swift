//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class CoinViewController: UIViewController {
    
    @IBOutlet weak var bitcoinLbl: UILabel!
    @IBOutlet weak var currencyLbl: UILabel!
    @IBOutlet weak var currencyPickerView: UIPickerView!
    
    var coinMeneger = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coinMeneger.delegate = self
        
        currencyPickerView.delegate = self
        currencyPickerView.dataSource = self
    }
}

//MARK: - UIPickerViewDelegate and UIPickerViewDataSource

extension CoinViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinMeneger.currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinMeneger.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency = coinMeneger.currencyArray[row]
        coinMeneger.getCoinPrice(for: selectedCurrency)
        currencyLbl.text = selectedCurrency
    }
}

extension CoinViewController: CoinMenegerDelegate {
    func didUpdatePrice(price: String, currency: String) {
        DispatchQueue.main.async {
            self.bitcoinLbl.text = price
        }
    }
    
    func didFailWithError(error: Error) {
        print(error.localizedDescription)
    }
    
    
}


