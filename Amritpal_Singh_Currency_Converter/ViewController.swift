//
//  ViewController.swift
//  Amritpal_Singh_Currency_Converter
//
//  Created by Singh Singh on 2019-07-17.
//  Copyright © 2019 teamrit. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var currencyModel = CurrencyConversionModel()
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    var exchangeRate = 0.0
    
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var toTextField: UITextField!
    
    @IBOutlet weak var fromView: UIView!
    @IBOutlet weak var toView: UIView!
    
    @IBOutlet weak var fromCurrencyLabel: UILabel!
    @IBOutlet weak var toCurrencyLabel: UILabel!
    
    var fromCurrency = "CAD"
    var toCurrency = "USD"
    
    @IBOutlet weak var convertButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        
        makeButtonRound(button: convertButton, 3.0, 10)
        makeViewRound(view: fromView, 0, 10)
        makeViewRound(view: toView, 0, 10)
        setDefaultLabelValue()
        
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func setDefaultLabelValue() {
        fromCurrencyLabel.text = fromCurrency
        toCurrencyLabel.text = toCurrency
        fromTextField.keyboardType = .decimalPad
        fromTextField.text = "1.0"
    }
    
    func animateLoading() {
        UIView.animate(withDuration: 1.5, animations: {
//            self.myFirstLabel.alpha = 1.0
//            self.myFirstButton.alpha = 1.0
//            self.mySecondButton.alpha = 1.0
        })
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyModel.currencies.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyModel.currencies[row]
    }
    
    func addPadding(view: UIView, value: CGFloat) {
        view.layoutMargins = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10);
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // use the row to get the selected row from the picker view
        print()
        
        if (component == 0) {
            print("from \(currencyModel.currencies[row])")
            fromCurrencyLabel.text = currencyModel.currencies[row]
        } else if component == 1 {
            print("to  \(currencyModel.currencies[row])")
            toCurrencyLabel.text = currencyModel.currencies[row]
        }
        
        // using the row extract the value from your datasource (array[row])
    }
    
   
    
    func makeButtonRound(button : UIButton, _ value : CGFloat, _ cornerRadius: CGFloat) {
        button.layer.cornerRadius = cornerRadius
        button.layer.borderWidth = value
        button.layer.borderColor = UIColor.white.cgColor
    }
    
    func makeViewRound(view : UIView, _ value : CGFloat, _ cornerRadius: CGFloat) {
        view.layer.cornerRadius = cornerRadius
        view.layer.borderWidth = value
        view.layer.borderColor = UIColor.white.cgColor
    }
    
    @IBAction func convertCurrency(_ sender: Any) {
        makeRequest()
    }
    
    func makeRequest() {
        
        let API_BASE_URL = "https://api.exchangeratesapi.io/latest?";
        
//        fromCurrency = currencyModel.currencies[from]
//        toCurrency = currencyModel.currencies[to]
        fromCurrency = fromCurrencyLabel.text!
        toCurrency = toCurrencyLabel.text!
        
        let api_url = "\(API_BASE_URL)base=\(fromCurrency)&symbols=\(toCurrency)"
        
        if let url = URL(string: api_url) {
            let dataTask = URLSession.shared.dataTask(with: url) {
                data, response, error in
                if let dataRecieved = data {
                    let jsonString = String(data: dataRecieved, encoding: .utf8)
                    print("recieved \(jsonString)")
                    
                    do {
                        let json = try JSON(data: dataRecieved)
                        if let exchangeRate = json["rates"][self.toCurrency].double {
                            
                            if let fromText = self.fromTextField.text {
                                self.toTextField.text = String(Double(fromText)! * exchangeRate)
                            }
                        }
                    } catch let err {
                        print("failed to create JSON object, \(err)")
                    }
                }
            }
            dataTask.resume()
        }
    
    }


}

