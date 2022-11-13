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
    
    init(productBarcode: String){
        _products = FetchRequest<Produk>(sortDescriptors: [SortDescriptor(\.kode)],
                                         predicate: NSPredicate(format: "kode == %@", productBarcode),
                                         animation: .default
        )
    }
    
    
    @ObservedObject var tokoViewModel: TokoViewModel = TokoViewModel()
    @Environment(\.dismiss) var dismiss
    
    @State var showAddProductView = false
    
    var body: some View {
        if(!products.isEmpty){
            NavigationView{
                VStack {
                    VStack {
                        Text(products.first?.nama ?? "").font(.system(.title2).bold())
                            .padding(.top)
                        Text("\(products.first?.harga ?? 0)/\(products.first?.satuan ?? "")").font(.system(.title3))
                            .padding(.bottom)
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .padding(EdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 30))
                    
                    VStack {
                        HStack {
                            Text("Kode")
                            Spacer()
                            Text("\(products.first?.kode ?? 1)")
                        }.padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 20))
                        Divider().padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                        HStack {
                            Text("Kategori")
                            Spacer()
                            Text("\(products.first?.kategori ?? "")")
                        }.padding(EdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20))
                    }
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .padding(EdgeInsets(top: 30, leading: 30, bottom: 0, trailing: 30))
                }
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
                            //                        dismiss()
                            self.showAddProductView.toggle()
                            
                        }, label: {
                            Text("Edit")
                        }).foregroundColor(.green)
                            .fullScreenCover(isPresented: self.$showAddProductView, content: {
                                AddProductView(showAddProductView: self.$showAddProductView)
                            })
                    }
                }
                .navigationTitle("Detail Product")
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
