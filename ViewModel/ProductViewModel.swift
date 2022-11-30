//
//  ProductViewModel.swift
//  Ikipiro
//
//  Created by Rivaldo Fernandes on 21/11/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import Foundation
import CoreData

class ProductViewModel: ObservableObject {
    private let persistenceController = PersistenceController.shared
    @Published var products: [Produk] = []
    @Published var selectedBarcodeProduk = ""
    @Published var tokos: [Toko] = []
    @Published var currentToko: Toko?
    @Published var currentTokoObjectID: NSManagedObjectID?
    
    @Published private var searchKeyword = ""
    @Published private var selectedCategory = ""
    
    @Published var productAutocomplete: ProductResponse?
    
    @Published var satuan = UserDefaults.standard.array(forKey: "units") as? [String]
    
    
    private func fetchProduct(){
        let request = NSFetchRequest<Produk>(entityName: "Produk")
        
        do {
            products = try persistenceController.persistentContainer.viewContext.fetch(request)
        }catch let error {
            print("Error Fetching. \(error)")
        }
    }
    
    func fetchProductFromAPI(productBarcode: String) async {
        print("hellooo callled")
        
        let networkMonitor = NetworkMonitor()
        
        DispatchQueue.main.async {
            self.productAutocomplete = nil
          }
        
        
        
        if networkMonitor.isConnected {
            print("connected callled")
            //create url
            guard let url = URL(string: "https://ikipiro.artesia.id/api/barcode/\(productBarcode)") else {
                return
            }
            //fetch data from that url
            do {
                print("do callled")
                let (data, _) = try await URLSession.shared.data(from: url)
                print(data)
                
                
                //decode data
                if let decodedResponse = try? JSONDecoder().decode(ProductResponse.self, from: data){
                    print("if let callled")
                    DispatchQueue.main.async {
                        self.productAutocomplete = decodedResponse
                      }
                    
                    print(productAutocomplete?.nama ?? "GK NAMPIL")
                }
            } catch {
                print("catch callled")
                print("bad news, not valid data")
            }
        }
    }
    
    func fetchProductByToko(toko: Toko){
        
        let productsResult = toko.produk?.allObjects as! [Produk]
        
        if(productsResult.isEmpty){
            products = []
        }else{
            self.products = productsResult
        }
    }
    
    
    func fetchProductInToko(toko: Toko) -> [Produk] {
        //        return toko.produk?.allObjects as! [Produk]
        
        let productsResult = toko.produk?.allObjects as! [Produk]
        
        if(productsResult.isEmpty){
            return []
        }else{
            return productsResult
        }
    }
    
    func fetchProductFromCurrentToko(){
        if (self.currentToko != nil){
            let productsResult = self.currentToko!.produk?.allObjects as [Produk]
            
            if(productsResult.isEmpty){
                self.products = []
            }else{
                self.products = productsResult
            }
        }else{
            self.products = []
        }
    }
    
    
    func fetchProductWithToko(){
        //        return toko.produk?.allObjects as! [Produk]
//        if(self.currentToko != nil){
//            let productsResult = self.currentToko!.produk?.allObjects as! [Produk]
//
//            if(productsResult.isEmpty){
//                self.products = []
//            }else{
//                self.products = productsResult
//            }
//        }else{
            fetchTokos()
            var objectIDString = UserDefaults.standard.object(forKey: "selectedToko")

            // Use the persistent store coordinator to transform the string back to an NSManagedObjectID.
            if let objectIDURL = URL(string: objectIDString as! String) {
                let coordinator: NSPersistentStoreCoordinator = persistenceController.persistentContainer.viewContext.persistentStoreCoordinator!
                let managedObjectID = coordinator.managedObjectID(forURIRepresentation: objectIDURL)
                
                let request = NSFetchRequest<Produk>(entityName: "Produk")
                
                request.predicate = NSPredicate(format: "toko == %@", managedObjectID!)
                
                do {
                    products = try persistenceController.persistentContainer.viewContext.fetch(request)
                }catch let error {
                    print("Error Fetching. \(error)")
                }
                
                
                
            }
    }
    
    func fetchTokos(){
        let request = NSFetchRequest<Toko>(entityName: "Toko")
        do {
            tokos = try persistenceController.persistentContainer.viewContext.fetch(request)
        }catch let error {
            print("Error Fetching. \(error)")
        }
    }
    
    func setCurrentTokoForFirst(){
        fetchTokos()
        self.currentToko = tokos.first!
    }
    
    func setCurrentTokoToUserDefault(){
        if(self.currentToko != nil){
            let objectIDString = self.currentToko!.objectID.uriRepresentation().absoluteString
            UserDefaults.standard.set(objectIDString, forKey: "selectedToko")
        }
    }
    
    func getCurrentTokoIDFromUserDefault() -> String? {
        let result = UserDefaults.standard.object(forKey: "selectedToko") as? String
        
        if result == nil {
            return nil
        }else{
            return result
        }
    }
    
    
    func setCurrentTokoById(objectIDString: String){
        if let objectIDURL = URL(string: objectIDString ) {
            let coordinator: NSPersistentStoreCoordinator = persistenceController.persistentContainer.viewContext.persistentStoreCoordinator!
            let managedObjectID = coordinator.managedObjectID(forURIRepresentation: objectIDURL)
            
            let request = NSFetchRequest<Toko>(entityName: "Toko")
            request.predicate = NSPredicate(format: "self == %@", managedObjectID!)
        
            do {
                let toko = try persistenceController.persistentContainer.viewContext.fetch(request).first
                
                if toko == nil {
                    fetchTokos()
                    self.currentToko = tokos.first!
                }else {
                    self.currentToko = toko
                }
            }catch let error {
                print("Error Fetching. \(error)")
            }
        }
    }
    
    func filteredProduct(searchKey: String? = nil, category: String? = nil){
        if searchKey != nil {
            self.searchKeyword = searchKey!
        }
        
        if category != nil {
            self.selectedCategory = category!
        }
        
        fetchProduct()
        if(self.searchKeyword.isEmpty){
            if(self.selectedCategory.isEmpty){
                
            }else{
//                products = products.filter { $0.kategori == category}
            }
        }else{
            if(self.selectedCategory.isEmpty){
                products = products.filter{ ($0.nama?.contains(self.searchKeyword))!}
            }else{
//                products = products.filter{(($0.nama?.contains(self.searchKeyword))! && $0.kategori == self.selectedCategory)}
            }
        }
    }
    
    
    func deleteProduct(indexSet: IndexSet){
        guard let index = indexSet.first else { return }
        let currentProduct = products[index]
        persistenceController.deleteProduk(currentProduct)
        
    }
    
    private func fetchToko() -> Toko? {
        let request = NSFetchRequest<Toko>(entityName: "Toko")
        do {
            let toko = try persistenceController.persistentContainer.viewContext.fetch(request).first
            return toko
        }catch let error {
            print("Error Fetching. \(error)")
            return nil
        }
    }
    func fetchTokoByObjectID() -> Toko? {
        let request = NSFetchRequest<Toko>(entityName: "Toko")
        self.getObjectID()
        
        request.predicate = NSPredicate(format: "self == %@", currentTokoObjectID!)
    
        do {
            let toko = try persistenceController.persistentContainer.viewContext.fetch(request).first
            
            print("KONTOOOLLLLLL ANJINGG")
            self.currentToko = toko
            print(toko)
            return toko
        }catch let error {
            print("Error Fetching. \(error)")
            print("KONTOOOLLLLLL")
            return nil
        }
    }
    
    func addProduct(nama: String,satuan: String, harga: Double, kode: Int64, deskripsi: String){
        guard let toko = self.currentToko else { return }
        
        print(toko.namaToko ?? "GK NAMPIL")
        
        persistenceController.addProduk(nama: nama, satuan: satuan, harga: harga, kode: kode, deskripsi: deskripsi, relateTo: toko)
    }
    
    func editProduct(nama: String,satuan: String, harga: Double, deskripsi: String, product: Produk){
        persistenceController.editProduk(produk: product, nama: nama, satuan: satuan, harga: harga, deskripsi: deskripsi)
    }
    
    func containsProduct(productBarcode: String) -> Bool {
        let request = NSFetchRequest<Produk>(entityName: "Produk")
        request.predicate = NSPredicate(format: "kode = %@", productBarcode)
        
        do {
            let result = try persistenceController.persistentContainer.viewContext.fetch(request)
            
            return !result.isEmpty
            
        } catch let error {
            print("Error Fetching. \(error)")
            return false
        }
    }
    
    func getProduct(productBarcode: String) -> Produk? {
        let request = NSFetchRequest<Produk>(entityName: "Produk")
        request.predicate = NSPredicate(format: "kode = %@", productBarcode)
        
        do {
            let result = try persistenceController.persistentContainer.viewContext.fetch(request)
            
            return result.first
            
        } catch let error {
            print("Error Fetching. \(error)")
            return nil
        }
    }
    
    func getObjectID(){
        
        var objectIDString = UserDefaults.standard.object(forKey: "selectedToko")
        // Use the persistent store coordinator to transform the string back to an NSManagedObjectID.
        if let objectIDURL = URL(string: objectIDString as! String) {
            let coordinator: NSPersistentStoreCoordinator = persistenceController.persistentContainer.viewContext.persistentStoreCoordinator!
            let managedObjectID = coordinator.managedObjectID(forURIRepresentation: objectIDURL)
            
//            let request = NSFetchRequest<Produk>(entityName: "Produk")
//
//            request.predicate = NSPredicate(format: "toko == %@", managedObjectID!)
//
//            do {
//                products = try persistenceController.persistentContainer.viewContext.fetch(request)
//            }catch let error {
//                print("Error Fetching. \(error)")
//            }
            
            self.currentTokoObjectID = managedObjectID
            
        }
        
     
    }
}



