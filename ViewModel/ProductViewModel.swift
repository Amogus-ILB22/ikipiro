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
    
    @Published private var searchKeyword = ""
    @Published private var selectedCategory = ""
    
    private func fetchProduct(){
        let request = NSFetchRequest<Produk>(entityName: "Produk")
        
        do {
            products = try persistenceController.persistentContainer.viewContext.fetch(request)
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
    
    func fetchToko() -> Toko? {
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
        guard let toko = fetchToko() else { return }
        
        persistenceController.addProduk(nama: nama, satuan: satuan, harga: harga, kode: kode, kategori: kategori, relateTo: toko)
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
