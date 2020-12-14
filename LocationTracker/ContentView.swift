//
//  ContentView.swift
//  LocationTracker
//
//  Created by Shaun Fowler on 2020-11-14.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            VStack {
                MapView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(CoordinatePath())
    }
}
