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
   
    func addProduk(nama: String,satuan: String, harga: Double, kode: Int64, deskripsi: String , image: Data?, relateTo toko: Toko) {
        if let context = toko.managedObjectContext {
            context.performAndWait {
                let produk = Produk(context: context)
                produk.toko = toko
                produk.nama = nama
                produk.satuan = satuan
                produk.harga = harga
                produk.kode = kode
                produk.deskripsi = deskripsi
                produk.photo = image
                
                context.save(with: .addProduk)
                
            }
        }else {
            print("No context")
        }
    }
    
    func editProduk(produk: Produk,nama: String, satuan: String, harga: Double , deskripsi: String, image: Data?){
        if let context = produk.toko!.managedObjectContext {
            context.performAndWait {
                produk.nama = nama
                produk.deskripsi = deskripsi
                produk.satuan = satuan
                produk.harga = harga
                produk.photo = image
                context.save(with: .updateProduk)
                
            }
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
