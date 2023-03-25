//
//  InternetConnectionView.swift
//  Saga
//
//  Created by Stavan Gandhi on 6/14/22.
//

import Foundation
import SwiftUI
import Network

final class NetworkMonitor: ObservableObject {
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "Monitor")
    
    @Published var isConnected = true
    
    init() {
        monitor.pathUpdateHandler =  { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied ? true : false
            }
        }
        monitor.start(queue: queue)
    }
}

struct InternetDisconnectedView: View {
    @ObservedObject var monitor = NetworkMonitor()
    @State private var showAlertSheet = false
    
    var body: some View {
        VStack {
            Image(systemName: monitor.isConnected ? "wifi" : "wifi.slash")
                .font(.system(size: 56))
            Text(monitor.isConnected ? "Connected!" : "Not connected!")
                .padding()
            Button("Refresh! Perform Network Request") {
                self.showAlertSheet = true
            }
        }
        .alert(isPresented: $showAlertSheet, content: {
            return Alert(title: Text("No Internet Connection"), message: Text("Please enable Wifi or Celluar data."), dismissButton: .default(Text("OK")))
        })
    }
}
