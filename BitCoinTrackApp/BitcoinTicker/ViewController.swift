
import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    let currencySymbolArray = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    
    var currencySelected = ""
    var finalURL = ""
    
    // Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    // this method is used to tell the uipicker how many colums it should have
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // this method is used to tell the uipicker how many rows it should have
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    // this method is used to populate the data in the uipicker by adding the names of currency
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    // this method is used for sending which currency we selected from the view
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        finalURL = baseURL + currencyArray[row]
        currencySelected = currencySymbolArray[row]
        getBitcoinData(url: finalURL)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
    }

    //MARK: - Networking
    /***************************************************************/
    
    // this method makes an http request to the endpoint specified to get bitcoin data
    func getBitcoinData(url: String) {
        
        // uses alamofire to do a get https request to the url defined above
        Alamofire.request(url, method: .get).responseJSON {
            response in
            if (response.result.isSuccess) {
                print("Sucess! Got the Bitcoin data")
                let bitcoinJSON : JSON = JSON(response.result.value!)
                self.updateBitcoinData(json: bitcoinJSON)
            }
            else {
                print("Error: \(String(describing: response.result.error))")
                self.bitcoinPriceLabel.text = "Connection Issues"
            }
        }
        
    }
    
    
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
    
    // this method parses the JSON data and grabs the asking price
    func updateBitcoinData(json : JSON) {
        
        // if our json request was not nil then we will append the price to the view
        if let bitcoinResult = json["ask"].double {
            bitcoinPriceLabel.text = "\(currencySelected)\(bitcoinResult)"
        }
        else {
            bitcoinPriceLabel.text = "Price Unavailable"
        }
    }
    
}

