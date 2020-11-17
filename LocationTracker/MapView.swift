//
//  MapView.swift
//  LocationTracker
//
//  Created by Shaun Fowler on 2020-11-15.
//

import SwiftUI
import MapKit

class MKMapViewCoordinator: NSObject, MKMapViewDelegate {
    var parent: MapView

    init(_ parent: MapView) {
        self.parent = parent
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let lineView = MKPolylineRenderer(overlay: overlay)
            lineView.strokeColor = .green
            return lineView
        }

        fatalError("Unexpected overlay type")
    }
}

class CoordinatePath: ObservableObject {
    @Published var coordinates: [CLLocationCoordinate2D] = []
}

struct MapView: UIViewRepresentable {

    @EnvironmentObject var path: CoordinatePath

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.setRegion(
            MKCoordinateRegion(
                center: mapView.userLocation.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)),
            animated: true)
        return mapView
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        let coords: [CLLocationCoordinate2D] = [
            .init(latitude: 33.98995557, longitude: -118.44562951),
            .init(latitude: 33.97995557, longitude: -118.45562951),
            .init(latitude: 33.96995557, longitude: -118.43562951),
            .init(latitude: 33.95995557, longitude: -118.42562951),
        ]
        view.addOverlay(MKPolyline(coordinates: coords, count: coords.count))
    }

    func makeCoordinator() -> MKMapViewCoordinator {
        MKMapViewCoordinator(self)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
