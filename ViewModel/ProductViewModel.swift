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
    
    @Published private var searchKeyword = ""
    @Published private var selectedCategory = ""
    
    @Published var productAutocomplete: ProductResponse?
    
    
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
    
    func fetchProductWithToko(){
        //        return toko.produk?.allObjects as! [Produk]
        if(self.currentToko != nil){
            let productsResult = self.currentToko!.produk?.allObjects as! [Produk]
            
            if(productsResult.isEmpty){
                self.products = []
            }else{
                self.products = productsResult
            }
        }else{
            fetchTokos()
            self.currentToko = tokos.first!
            if(self.currentToko != nil){
                let productsResult = self.currentToko!.produk?.allObjects as! [Produk]
                
                if(productsResult.isEmpty){
                    self.products = []
                }else{
                    self.products = productsResult
                }
                
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
                products = products.filter { $0.kategori == category}
            }
        }else{
            if(self.selectedCategory.isEmpty){
                products = products.filter{ ($0.nama?.contains(self.searchKeyword))!}
            }else{
                products = products.filter{(($0.nama?.contains(self.searchKeyword))! && $0.kategori == self.selectedCategory)}
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
    
    func addProduct(nama: String,satuan: String, harga: Double, kode: Int64,kategori: String){
        guard let toko = self.currentToko else { return }
        
        persistenceController.addProduk(nama: nama, satuan: satuan, harga: harga, kode: kode, kategori: kategori, relateTo: toko)
    }
    
    func editProduct(nama: String,satuan: String, harga: Double, kategori: String, product: Produk){
        persistenceController.editProduk(produk: product, nama: nama, satuan: satuan, harga: harga, kategori: kategori)
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
}
