//
//  MainProductListView.swift
//  Ikipiro
//
//  Created by Rivaldo Fernandes on 22/11/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import Foundation
import SwiftUI


struct MainProductListView: View {
    @StateObject var productViewModel = ProductViewModel()
    @State private var searchText = ""
    @State private var showDetailProduct = false
    
    var body: some View {
        //        List{
        //            ForEach(vm.products){ product in
        //                Text(product.nama ?? "")
        //            }
        //        }
        //        .onAppear{
        //            vm.fetchProduct()
        //            print(vm.containsProduct(productBarcode: "666"))
        //        }
        
        NavigationView {
            VStack {
                ScrollView {
                    if productViewModel.products.isEmpty {
                        Spacer()
                        Text("Tambahkan produk di toko anda.").padding()
                            .multilineTextAlignment(.center)
                        Spacer()
                    } else {
                        ForEach(productViewModel.products, id: \.self) { produk in
                            Button(action: {
                                productViewModel.selectedBarcodeProduk = String(produk.kode)
                                self.showDetailProduct.toggle()
                                
                            }, label: {
                                HStack(){
                                    HStack(){
                                        VStack(alignment: .leading){
                                            //                                    HStack(){
                                            Text(produk.nama ?? "")
                                                .frame(maxWidth: .infinity,alignment: .leading)
                                                .multilineTextAlignment(.leading)
                                                .font(.system(.title3, design: .rounded))
                                            
                                            
                                            //                                    }
                                            
                                            //                                    HStack(){
                                            Text(produk.kategori ?? "")
                                                .frame(maxWidth: .infinity,alignment: .leading)
                                                .multilineTextAlignment(.leading)
                                                .foregroundColor(.gray)
                                                .font(.system(.callout, design: .rounded))
                                            //                                    }
                                            
                                        }
                                        .padding(.leading, 10)
                                        
                                        .frame(maxWidth: .infinity)
                                        
                                        //                                Spacer()
                                        VStack(alignment : .trailing){
                                            Text(DetailProductView.df2so(produk.harga))
                                                .font(.system(.title3, design: .rounded))
                                                .foregroundColor(Color("GreenButton"))
                                                .fontWeight(.bold)
                                                .frame(maxWidth: .infinity,alignment: .trailing)
                                                .multilineTextAlignment(.leading)
                                                .lineLimit(1)
                                            
                                            Text("/\(produk.satuan ?? "") ")
                                                .font(.system(.caption, design: .rounded))
                                                .fontWeight(.bold)
                                                .foregroundColor(Color("GreenButton"))
                                                .frame(maxWidth: .infinity,alignment: .trailing)
                                                .font(.caption)
                                            
                                        }.padding(.trailing, 5)
                                    }
                                    .padding()
                                    .frame(width : UIScreen.main.bounds.width*18/20, alignment: .center)
                                    .background(Color.white)
                                    
                                    .cornerRadius(10)
                                    .shadow(color: Color(hue: 1.0, saturation: 1.0, brightness: 0.001, opacity: 0.1), radius: 10, x: 0, y: 0)
                                    .padding(.bottom,5)
                                    
                                    
                                }.frame(width : UIScreen.main.bounds.width*1, alignment: .center)
                            })
                            .sheet(isPresented: self.$showDetailProduct, content: {
                                DetailProductView(productBarcode: productViewModel.selectedBarcodeProduk)
                            })
                            
                            
                        }
                        
                    }
                }
                .onAppear{
                    productViewModel.fetchProduct()
                }
                
                
                
                Button(action: {
                    withAnimation {
                        //                        self.showAddProductView.toggle()
                    }
                }) {
                    Text("Tambah Produk")
                        .font(.system(.headline, design: .rounded))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .background(Color("GreenButton"))
                        .cornerRadius(10)
                }.padding(.horizontal)
                    .padding(.bottom,10)
            }
            //            .fullScreenCover(isPresented: self.$showAddProductView, content: {
            //                AddProductView(showAddProductView: self.$showAddProductView)
            //            })
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        //                        tokoModel.openProdukFilter.toggle()
                        
                    }) {
                        Label("", systemImage: "line.3.horizontal.decrease.circle").labelStyle(.iconOnly).foregroundColor(Color("GreenButton"))
                    }
                    //                    .sheet(isPresented: $tokoModel.openProdukFilter, content: {
                    //                        ProductFilterByCategoryView(tokoModel: tokoModel, selectedItem: self.$selectedCategory)
                    //                    })
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    VStack(alignment: .leading) {
                        Text("Produk")
                            .font(.system(.title, design: .rounded)).fontWeight(.bold)
                            .foregroundColor(Color.black)
                        
                        
                        Spacer()
                    }
                }
            }
            .searchable(text: $searchText)
            .navigationBarTitleDisplayMode(.inline)
            
        }.navigationViewStyle(.stack)
        
    }
}

struct MainProductListView_Previews: PreviewProvider {
    static var previews: some View {
        MainProductListView()
    }
}
