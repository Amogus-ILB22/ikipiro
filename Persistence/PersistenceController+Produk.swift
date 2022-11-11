/*
See LICENSE folder for this sample’s licensing information.

Abstract:
An extension that wraps the related methods for managing ratings.
*/

import Foundation
import CoreData

// MARK: - Convenient methods for managing ratings.
//
extension PersistenceController {
   
    func addProduk(nama: String,satuan: String, harga: Double, kode: Int32,kategori: String , relateTo toko: Toko) {
        if let context = toko.managedObjectContext {
            context.performAndWait {
                let produk = Produk(context: context)
                produk.toko = toko
                produk.nama = nama
                produk.satuan = satuan
                produk.harga = harga
                produk.kode = kode
                produk.kategori = kategori
                
                context.save(with: .addProduk)
                
            }
            
            
        }else {
            print("No context")
        }
        
    }
    
    func deleteProduk(_ produk: Produk) {
        if let context = produk.managedObjectContext {
            context.performAndWait {
                context.delete(produk)
                context.save(with: .deleteProduk)
            }
        }
    }
}
