//
//  NetworkMonitor.swift
//  Ikipiro
//
//  Created by Rivaldo Fernandes on 30/11/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import Foundation
import Network


final class NetworkMonitor: ObservableObject {
    let monitor = NWPathMonitor()
    
    let queue = DispatchQueue(label: "Monitor")
    
    
    @Published var isConnected = true
    init () {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied ? true : false
            }
        }
        
        monitor.start(queue: queue)
    }
}

