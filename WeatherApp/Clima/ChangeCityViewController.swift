
import UIKit


// declaring the protocol used to pass data to the first view
protocol ChangeCityDelegate {
    func userEnteredANewCityName(city: String)
}

class ChangeCityViewController: UIViewController {
    
    var delegate : ChangeCityDelegate?
    
    // textfield to enter city name
    @IBOutlet weak var changeCityTextField: UITextField!
    
    // button pressed when a city name is typed
    @IBAction func getWeatherPressed(_ sender: AnyObject) {
        // grabs the city name the user entered in the text field
        let cityName = changeCityTextField.text!
        // if we have a delegate set, call the method userEnteredANewCityName
        delegate?.userEnteredANewCityName(city: cityName)
        // dismiss the Change City View Controller to go back to the first view
        self.dismiss(animated: true, completion: nil)
    }
    
    // gets called when the user taps the back button. It dismisses the ChangeCityViewController.
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
