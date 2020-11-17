//
//  AppDelegate.swift
//  LocationTracker
//
//  Created by Shaun Fowler on 2020-11-14.
//

import UIKit
import CoreData
import CoreLocation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    private let locationManager = CLLocationManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        locationManager.delegate = self

        getInitialLocationAndStartMonitoring()

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "LocationTracker")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension AppDelegate {
    func getInitialLocationAndStartMonitoring() {
        let status = CLLocationManager.authorizationStatus()

        if(status == .denied || status == .restricted || !CLLocationManager.locationServicesEnabled()){
            // show alert to user telling them they need to allow location data to use some feature of your app
            return
        }

        // if haven't show location permission dialog before, show it to user
        if(status == .notDetermined){
            locationManager.requestWhenInUseAuthorization()

            // if you want the app to retrieve location data even in background, use requestAlwaysAuthorization
            // locationManager.requestAlwaysAuthorization()
            return
        }

        // at this point the authorization status is authorized
        // request location data once
        locationManager.requestLocation()

        // start monitoring location data and get notified whenever there is change in location data / every few seconds, until stopUpdatingLocation() is called
        locationManager.startUpdatingLocation()
    }
}

extension AppDelegate: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            getInitialLocationAndStartMonitoring()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            print("didUpdateLocations - location: \(location.debugDescription)")
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError: \(error)")
    }
}
