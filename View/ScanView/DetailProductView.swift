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
    
    @StateObject var vm = ProductViewModel()
    
    
//    @FetchRequest var products: FetchedResults<Produk>
    @State var productBarcode: String
    @State var currentProduct: Produk? = nil
    
//    init(productBarcode: String){
//        _products = FetchRequest<Produk>(sortDescriptors: [SortDescriptor(\.kode)],
//                                         predicate: NSPredicate(format: "kode == %@", productBarcode),
//                                         animation: .default
//        )
//        _productBarcode = State(initialValue: productBarcode)
//    }
    
    
    @ObservedObject var tokoViewModel: TokoViewModel = TokoViewModel()
    @Environment(\.dismiss) var dismiss
    @State var showAddProductView = false
    
    var body: some View {
            NavigationView{
                if(currentProduct != nil){
                    VStack {
                        List{
                            Section {
                                HStack {
                                    Text("Kode")
                                        .font(.system(.body)).bold()
                                        .foregroundColor(.black)
                                    Spacer()
                                    Text(String(currentProduct?.kode ?? 0))
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
                                    Text(currentProduct?.nama ?? "")
                                        .font(.system(.body))
                                        .foregroundColor(.black)
                                }
                                
                                HStack {
                                    Text("Harga")
                                        .font(.system(.body)).bold()
                                        .foregroundColor(.black)
                                    Spacer()
    //                                Text(NumberFormatter.localizedString(from: (products.first?.harga ?? 0) as NSNumber, number: .ordinal))
                                    Text(DetailProductView.df2so(currentProduct?.harga ?? 0))
    //                                Text(String(format: "Rp %.02f", products.first?.harga ?? 0))
                                        .font(.system(.body))
                                        .foregroundColor(.black)
                                }
                                
                                HStack {
                                    Text("Kategori")
                                        .font(.system(.body)).bold()
                                        .foregroundColor(.black)
                                    Spacer()
                                    Text("\(currentProduct?.kategori ?? "")")
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
//                                .fullScreenCover(isPresented: self.$showAddProductView, content: {
//                                    EditProductView(productBarcode:  self.productBarcode, productName: currentProduct?.nama ?? "",productPrice: "\(currentProduct.harga ?? 0)",productCategory: currentProduct?.kategori ?? "", productUnit: UnitProduct.init(rawValue: currentProduct?.satuan ?? "")!, produk: currentProduct ?? <#default value#>, showAddProductView: self.$showAddProductView)
//                                    
//                                })
                        }
                    }
                    .navigationTitle("Informasi Produk")
                    .navigationBarTitleDisplayMode(.inline)
                }
            }
            .onAppear{
                self.currentProduct = vm.getProduct(productBarcode: productBarcode) ?? Produk()
            }
        
            
    }
    
    static func df2so(_ price: Double) -> String{
           let numberFormatter = NumberFormatter()
           numberFormatter.groupingSeparator = "."
           numberFormatter.groupingSize = 3
           numberFormatter.usesGroupingSeparator = true
           numberFormatter.decimalSeparator = ","
           numberFormatter.numberStyle = .decimal
           numberFormatter.maximumFractionDigits = 2
           return "Rp " + numberFormatter.string(from: price as NSNumber)!
       }
    
}

struct DetailProductView_Previews: PreviewProvider {
    static var previews: some View {
        DetailProductView(productBarcode: "")
    }
}


