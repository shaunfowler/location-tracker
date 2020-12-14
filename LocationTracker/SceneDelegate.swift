//
//  SceneDelegate.swift
//  LocationTracker
//
//  Created by Shaun Fowler on 2020-11-14.
//

import UIKit
import SwiftUI
import CoreLocation

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let locationManager = CLLocationManager()
    var coordinatePath = CoordinatePath()

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {

        locationManager.delegate = self
        getInitialLocationAndStartMonitoring()

        let contentView = ContentView()
            .environmentObject(coordinatePath)

        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}

extension SceneDelegate {
    func getInitialLocationAndStartMonitoring() {
        // If previously denied, do nothing.
        let status = CLLocationManager.authorizationStatus()
        if status == .denied || status == .restricted || !CLLocationManager.locationServicesEnabled() {
            return
        }

        // If haven't show location permission dialog before, show it.
        if(status == .notDetermined){
            locationManager.requestAlwaysAuthorization()
            return
        }

        // Request location updates.
        locationManager.distanceFilter = 10.0
        locationManager.requestLocation()
        locationManager.startUpdatingLocation()
    }
}



extension SceneDelegate: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            getInitialLocationAndStartMonitoring()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last, location.horizontalAccuracy < 15 {
            coordinatePath.coordinates.append(location.coordinate)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError: \(error)")
    }
}
