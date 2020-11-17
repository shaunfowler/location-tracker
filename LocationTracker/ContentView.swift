//
//  ContentView.swift
//  LocationTracker
//
//  Created by Shaun Fowler on 2020-11-14.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        MapView().edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
