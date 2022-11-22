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
    @Environment(\.dismiss) var dismiss
    @StateObject var vm = ProductViewModel()
    
    @State var productBarcode: String
    @State var currentProduct: Produk? = nil
    
    
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
                                Text(DetailProductView.df2so(currentProduct?.harga ?? 0))
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
                        
                            .fullScreenCover(isPresented: self.$showAddProductView, content: {
                                EditProductView(currentProduct: self.currentProduct!, showAddProductView: self.$showAddProductView)
                            })
                    }
                }
                .navigationTitle("Informasi Produk")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        .onAppear{
            self.currentProduct = vm.getProduct(productBarcode: productBarcode) ?? Produk()
        }
        .onChange(of: self.showAddProductView){ _ in
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


