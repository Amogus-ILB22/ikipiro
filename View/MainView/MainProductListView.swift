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
//    @StateObject var productViewModel = ProductViewModel()
    @EnvironmentObject var productViewModel: ProductViewModel
    @State private var searchText = ""
    @State private var selectedCategory = ""
    
    @State private var showDetailProduct = false
    @State private var showAddProductView = false
    @State private var showProductFilter = false
    
    var body: some View {
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
                                RowItemProductList(productName: produk.nama ?? "", productImage: nil, productPrice: DetailProductView.df2so(produk.harga), productUnit: produk.satuan ?? "")
                            })
                            .sheet(isPresented: self.$showDetailProduct, content: {
                                DetailProductView(productBarcode: productViewModel.selectedBarcodeProduk)
                            })
                            .padding()
                        }
                    }
                }
                .onAppear{
//                    productViewModel.filteredProduct()
                    productViewModel.fetchProductWithToko()
                    
//                    productViewModel.fetchTokos()
//                    print(productViewModel.tokos)
                    
                    print(productViewModel.products)
                    
                }
                .onChange(of: self.searchText){ value in
//                    productViewModel.filteredProduct(searchKey: value)
                    productViewModel.fetchProductWithToko()
                }
                .onChange(of: self.selectedCategory){ value in
//                    productViewModel.filteredProduct(category: value)
                    productViewModel.fetchProductWithToko()
                }
                .onChange(of: self.showDetailProduct){ _ in
//                    productViewModel.filteredProduct()
                    productViewModel.fetchProductWithToko()
                }
                .onChange(of: self.showAddProductView){ _ in
//                    productViewModel.filteredProduct()
                    productViewModel.fetchProductWithToko()
                }
            }
                        
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button(action: {
//                        self.showProductFilter.toggle()
//
//                    }) {
//                        Label("", systemImage: "line.3.horizontal.decrease.circle").labelStyle(.iconOnly).foregroundColor(Color("GreenButton"))
//                    }
//                    .sheet(isPresented: self.$showProductFilter, content: {
//                        ProductFilterByCategoryView(showProductFilter: self.$showProductFilter ,selectedItem: self.$selectedCategory)
//                    })
                    
                    Button (action: {
                        withAnimation {
                            self.showAddProductView.toggle()
                        }
                    }, label: {
                        HStack {
                            Text("Tambah Produk")
                                .font(.system(.callout).bold())
                                .foregroundColor(.black)
                            Image("plus")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxHeight: 20)
                        }
                        .padding(EdgeInsets(top: 3, leading: 8, bottom: 3, trailing: 8))
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(color: .gray, radius: 2, x: 0, y: 0)
                        
                    })
                    .fullScreenCover(isPresented: self.$showAddProductView, content: {
                        AddProductView(showAddProductView: self.$showAddProductView)
                    })
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
