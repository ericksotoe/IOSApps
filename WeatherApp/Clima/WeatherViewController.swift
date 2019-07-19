
import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON


class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate {
    
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "ea88de6fc49d410dbc9b4833249a4612"
    
    let locationmanager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    var isCelsius = true
    
    // IBOutlet used to display the weather data in the updateUI methods
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBAction func celsiusOrFarenheit(_ sender: Any) {
        if (isCelsius) {
            temperatureLabel.text = "\(weatherDataModel.temperature)°c"
        }
        else {
            let fahrenheit = weatherDataModel.temperature * 9/5 + 32
            temperatureLabel.text = "\(fahrenheit)°f"
        }
        isCelsius = !isCelsius
    }
    // loads when creating the the view by setting the delegate for location manager
    override func viewDidLoad() {
        super.viewDidLoad()
        // setting the location manager delegate to be our current class
        locationmanager.delegate = self
        // set the accuracy to be withing a hundred meters
        locationmanager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        // ask permission for current location popup
        locationmanager.requestWhenInUseAuthorization()
        // reads the phones location
        locationmanager.startUpdatingLocation()
    }
    
    // MARK: - Networking
    /***************************************************************/
    
    // this method takes the url, and the latitude, long, dict to get the data for the location
    func getWeatherData(url: String, parameters: [String : String]) {
        // http request to the url endpoint to get data using our params
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            
            // response contains the data that the https request gave us
            if (response.result.isSuccess) {
                // format the recieved data in JSON
                let weatherJSON : JSON = JSON(response.result.value!)
                // will parse the json and write it out how we want in the view
                self.updateWeatherData(json: weatherJSON)
            }
                // response did not contain any data or there was an error
            else {
                print("Error \(String(describing: response.result.error))")
                self.cityLabel.text = "Connection Issues"
            }
        }
    }
    
    // MARK: - JSON Parsing
    /***************************************************************/
    
    // this method parses the json and converts the data to how we want it to
    func updateWeatherData(json: JSON) {
        // if the JSON data is not nil then we will prepare it to be shown
        if let tempResult = json["main"]["temp"].double {
            // grab the temperature, cityName, condition of current location
            weatherDataModel.temperature = Int(tempResult - 273.15)
            weatherDataModel.city = json["name"].stringValue
            weatherDataModel.condition = json["weather"][0]["id"].intValue
            // gets the condition and finds the correct icon to display using our saved icons
            weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            updateUIWithWeatherData()
        }
            // if the json data is nil then we display weather unav
        else {
            cityLabel.text = "Weather Unavailable"
        }
    }
    
    // MARK: - UI Updates
    /***************************************************************/
    
    // this method updates the ui with the degrees, name of city entered, and grabs the correct icon
    func updateUIWithWeatherData() {
        cityLabel.text = weatherDataModel.city
        temperatureLabel.text = "\(weatherDataModel.temperature)°c"
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
    }
    
    // MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    // this method awaits for the location, when it is grabbed it will store into a dict grab from the site
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // get the latest value added to array of locations
        let location = locations[locations.count - 1]
        // if we have an invalid result do this
        if (location.horizontalAccuracy > 0) {
            locationmanager.stopUpdatingLocation()
            print("Longitude = \(location.coordinate.longitude), Latitude = \(location.coordinate.latitude)")
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            // holds the locatoin properties that will be used with weather api
            let params : [String : String] = ["lat" : latitude, "lon" : longitude, "appid" : APP_ID]
            
            getWeatherData(url: WEATHER_URL, parameters: params)
        }
    }
    
    // this method happens when we were not able to read the location of the phone
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location Unavailabe"
    }
    
    // MARK: - Change City Delegate methods
    /***************************************************************/
    
    // this method writes the userEnteredANewCityName Delegate
    func userEnteredANewCityName(city: String) {
        let params : [String : String] = ["q" : city, "appid" : APP_ID]
        getWeatherData(url: WEATHER_URL, parameters: params)
    }
    
    // this method prepares the data that will be sent to the second view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "changeCityName") {
            let destinationVC = segue.destination as! ChangeCityViewController
            destinationVC.delegate = self
        }
    }
    
    
    
    
}


