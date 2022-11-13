//
//  DetailProduct.swift
//  CoreDataCloudKitShare
//
//  Created by Rivaldo Fernandes on 12/11/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import Foundation
import SwiftUI

struct DetailProductView: View {
    //    @FetchRequest(sortDescriptors: [SortDescriptor(\.kode)],
    //                  predicate: NSPredicate(format: "kode == %@", productBarcode),
    //                  animation: .default
    //    ) private var products: FetchedResults<Produk>
    
    @FetchRequest var products: FetchedResults<Produk>
    @State var productBarcode: String
    
    init(productBarcode: String){
        _products = FetchRequest<Produk>(sortDescriptors: [SortDescriptor(\.kode)],
                                         predicate: NSPredicate(format: "kode == %@", productBarcode),
                                         animation: .default
        )
        _productBarcode = State(initialValue: productBarcode)
    }
    
    
    @ObservedObject var tokoViewModel: TokoViewModel = TokoViewModel()
    @Environment(\.dismiss) var dismiss
    
    @State var showAddProductView = false
    
    var body: some View {
        if(!products.isEmpty){
            NavigationView{
                VStack {
                    List{
                        Section {
                            HStack {
                                Text("Kode")
                                    .font(.system(.body)).bold()
                                    .foregroundColor(.black)
                                Spacer()
                                Text("\(products.first?.kode ?? 0)")
                                    .font(.system(.body))
                                    .foregroundColor(.black)
                            }
                        }
                        
                        Section {
                            HStack {
                                Text("Nama")
                                    .font(.system(.body)).bold()
                                    .foregroundColor(.black)
                                Spacer()
                                Text(products.first?.nama ?? "")
                                    .font(.system(.body))
                                    .foregroundColor(.black)
                            }
                            
                            HStack {
                                Text("Harga")
                                    .font(.system(.body)).bold()
                                    .foregroundColor(.black)
                                Spacer()
                                Text("\(products.first?.harga ?? 0)")
                                    .font(.system(.body))
                                    .foregroundColor(.black)
                            }
                            
                            HStack {
                                Text("Kategori")
                                    .font(.system(.body)).bold()
                                    .foregroundColor(.black)
                                Spacer()
                                Text("\(products.first?.kategori ?? "")")
                                    .font(.system(.body))
                                    .foregroundColor(.black)
                            }
                            
                        }
                        
                    }
                }
                .frame(maxWidth: .infinity)
                .toolbar{
                    ToolbarItem(placement: .navigationBarLeading){
                        Button(action: {
                            dismiss()
                        }, label: {
                            Text("Kembali")
                        }).foregroundColor(.green)
                    }
                    ToolbarItem(placement: .navigationBarTrailing){
                        Button(action: {
                            self.showAddProductView.toggle()
                            
                        }, label: {
                            Text("Edit")
                        }).foregroundColor(.green)
                            .fullScreenCover(isPresented: self.$showAddProductView, content: {
                                EditProductView(productBarcode: self.$productBarcode, productName: products.first?.nama ?? "",productPrice: "\(products.first?.harga ?? 0)",productCategory: products.first?.kategori ?? "", productUnit: UnitProduct.init(rawValue: products.first?.satuan ?? "")!, produk: products.first!, showAddProductView: self.$showAddProductView)
                                
                            })
                    }
                }
                .navigationTitle("Informasi Produk")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

struct DetailProductView_Previews: PreviewProvider {
    static var previews: some View {
        DetailProductView(productBarcode: "")
    }
}
