//
//  MapView.swift
//  LocationTracker
//
//  Created by Shaun Fowler on 2020-11-15.
//

import SwiftUI
import MapKit

class CoordinatePath: ObservableObject {
    @Published var coordinates: [CLLocationCoordinate2D] = []
}

// MARK: - Coordinator

class MKMapViewCoordinator: NSObject, MKMapViewDelegate {
    var parent: MKMapViewRepresentable
    var hasReceivedUserLocationOnce = false

    init(_ parent: MKMapViewRepresentable) {
        self.parent = parent
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let lineView = MKPolylineRenderer(overlay: overlay)
            lineView.strokeColor = .systemBlue
            lineView.lineWidth = 3
            return lineView
        }

        fatalError("Unexpected overlay type")
    }

    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if !hasReceivedUserLocationOnce  {
            hasReceivedUserLocationOnce = true
            mapView.userTrackingMode = .follow
        }
    }

    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        parent.userTrackingMode = mapView.userTrackingMode
    }
}

// MARK: - UIViewRepresentable

struct MKMapViewRepresentable: UIViewRepresentable {

    @EnvironmentObject var path: CoordinatePath
    @Binding var userTrackingMode: MKUserTrackingMode

    // MARK: - UIViewRepresentable

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        return mapView
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        view.userTrackingMode = userTrackingMode
        view.addOverlay(MKPolyline(coordinates: path.coordinates, count: path.coordinates.count))
    }

    func makeCoordinator() -> MKMapViewCoordinator {
        MKMapViewCoordinator(self)
    }
}

// MARK: - View

struct MapView: View {

    @State var userTrackingMode: MKUserTrackingMode = .none

    var body: some View {
        ZStack {
            MKMapViewRepresentable(userTrackingMode: $userTrackingMode)
                .edgesIgnoringSafeArea(.all)

            if userTrackingMode != MKUserTrackingMode.follow {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button("Center", action: {
                            self.userTrackingMode = .follow
                        })
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                        .frame(alignment: .bottomTrailing)
                    }
                }
                .padding()
            }
        }
    }

}

// MARK: - Previews

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MKMapViewRepresentable(userTrackingMode: Binding.constant(.follow))
    }
}
