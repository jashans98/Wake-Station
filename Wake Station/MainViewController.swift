//
//  MainViewController.swift
//  Wake Station
//
//  Created by Jashan Shewakramani on 2018-07-07.
//  Copyright © 2018 Jashan Shewakramani. All rights reserved.
//

import UIKit
import GoogleMaps
import SnapKit

class MainViewController: UIViewController {
    
    // MARK: - Static Properties
    static let distanceFilter: Double = 50
    static let defaultZoomLevel: Float = 16.0
    
    // MARK: - View Properties
    @IBOutlet var mapView: GMSMapView!
    @IBOutlet var destinationTextField: UITextField!
    @IBOutlet var searchResultsContainerView: UIView!
    @IBOutlet var searchResultsTableView: UIView!
    
    // MARK: - Other Properties
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    init() {
        super.init(nibName: String(describing: MainViewController.self), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - Lifecycle and Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeLocationManager()
        self.setupMapView()
        self.setupDestinationTextField()
        self.setupResultsTableView()
        self.searchResultsContainerView.isHidden = true
        
        // check location permissions whenever the app is foregrounded in case the user changed it
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(checkLocationPermissions),
            name: NSNotification.Name.UIApplicationDidBecomeActive,
            object: nil
        )
    }
    
    func initializeLocationManager() {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = MainViewController.distanceFilter
        self.checkLocationPermissions()
    }
    
    @objc func checkLocationPermissions() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            self.locationManager.requestAlwaysAuthorization()
        case .authorizedAlways:
            self.locationManager.startUpdatingLocation()
        default:
            self.promptUserToUpdateLocationSettings()
        }
    }
    
    func setupMapView() {
        self.mapView.isMyLocationEnabled = true
        self.mapView.isTrafficEnabled = true
        self.mapView.isIndoorEnabled = false
    }
    
    func setupResultsTableView() {
        // TODO: implement
    }
    
    func setupDestinationTextField() {
        self.destinationTextField.delegate = self
        self.destinationTextField.addTarget(
            self,
            action: #selector(textFieldDidChange(_:)),
            for: .editingChanged
        )
        
        // round corners and add shadows
        self.destinationTextField.roundCorners()
        self.destinationTextField.wrapShadow(withProperties: UIView.defaultShadowProperties)
        
        // add some left padding
        let leftPaddingView = UIView(frame: CGRect(
            x: 0,
            y: 0,
            width: 25,
            height: self.destinationTextField.frame.height
        ))
        self.destinationTextField.leftView = leftPaddingView
        self.destinationTextField.leftViewMode = .always
    }
    
    
    func mapCamera(to location: CLLocation, changeZoom: Bool = false) {
        let zoomLevel = changeZoom ? self.mapView.camera.zoom : MainViewController.defaultZoomLevel
        let cameraPosition = GMSCameraPosition.camera(
            withTarget: location.coordinate,
            zoom: zoomLevel
        )
        self.mapView.animate(to: cameraPosition)
    }
    
    func promptUserToUpdateLocationSettings() {
        let alertController = UIAlertController(
            title: NSLocalizedString("Location Permissions", comment: ""),
            message: NSLocalizedString(
                "You need to enable full location access for us to wake you up at your destination",
                comment: ""
            ),
            preferredStyle: .alert
        )
        
        let okButtonCompletionBlock: (UIAlertAction) -> Void = { (_) in
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }
            
            UIApplication.shared.open(settingsUrl)
        }
        
        let okAction = UIAlertAction(
            title: "OK",
            style: .default,
            handler: okButtonCompletionBlock
        )
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func toggleSearchResultsOverlay(visible: Bool) {
        self.searchResultsContainerView.isHidden = !visible
    }
}


// MARK: - CLLocationManagerDelegate
extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways:
            self.locationManager.startUpdatingLocation()
        default:
            self.promptUserToUpdateLocationSettings()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else {
            return
        }
        
        self.currentLocation = currentLocation
        self.mapCamera(to: currentLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError,
            error.code == .denied {
            self.promptUserToUpdateLocationSettings()
        }
    }
}

// MARK: - UITextFieldDelegate
extension MainViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.toggleSearchResultsOverlay(visible: true)
    }
    
    @objc func textFieldDidChange(_ textfield: UITextField) {
        // TODO: make your web requests and fetch nearby locations, refresh table view
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // TODO: validate that you have a candidate for a location, select it, and prompt
        //       the user to navigate to it; resign first responder status
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.toggleSearchResultsOverlay(visible: false)
    }
}


// MARK: - UITableViewDataSource, UITableViewDelegate
extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO: implement once we fetch results
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO: implement once we fetch results
        return tableView.dequeueReusableCell(withIdentifier: "id", for: indexPath)
    }
    
    
}
