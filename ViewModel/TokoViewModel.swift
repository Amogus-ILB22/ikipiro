//
//  TokoViewModel.swift
//  CoreDataCloudKitShare
//
//  Created by Muhammad Nur Faqqih on 10/11/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import Foundation
import CoreData


class TokoViewModel: ObservableObject {
    
    
    
    @Published var selectedToko = Toko()
    
    
    @Published var openAddProduk: Bool = false
    
    
    @Published var openProdukFilter: Bool = false
    
    @Published var currentBarcodeProduct: String = ""
    @Published var showDetailProduct: Bool = false
    
    
    //page control variable
    @Published var showAddProductPage: Bool = false
    
}
