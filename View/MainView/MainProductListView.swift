//
//  MainProductListView.swift
//  Ikipiro
//
//  Created by Rivaldo Fernandes on 22/11/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import Foundation
import SwiftUI
import CloudKit
import CoreData

struct MainProductListView: View {
    
    init(){
        Theme.navigationBarColors(background: .white, titleColor: .black)
    }
    
    
    @EnvironmentObject var productViewModel: ProductViewModel
    @State private var searchText = ""
    @State private var selectedCategory = ""
    
    @State private var showDetailProduct = false
    @State private var showAddProductView = false
    @State private var showProductFilter = false
    @State private var showStoreList = false
    
    var body: some View {
        NavigationView {
            VStack {
                GeometryReader { geometry in
                    ScrollView {
                        if productViewModel.products.isEmpty {
                            VStack{
                                HStack(alignment: .center, spacing: 0) {
                                    Image("mascot-empty").resizable()
                                        .aspectRatio( contentMode: .fit)
                                        .frame(maxWidth: UIScreen.main.bounds.width * 0.9)
                                }.frame(maxHeight: .infinity,alignment: .center)
                            }
                            
                            .frame(width: geometry.size.width)      // Make the scroll view full-width
                            .frame(minHeight: geometry.size.height)
                            
                            
                            
                        } else {
                            VStack{
                                ForEach(productViewModel.products, id: \.self) { produk in
                                    Button(action: {
                                        productViewModel.selectedBarcodeProduk = String(produk.kode)
                                        self.showDetailProduct.toggle()
                                        
                                    }, label: {
                                        RowItemProductList(productName: produk.nama ?? "", productImage: produk.photo, productPrice: DetailProductView.df2so(produk.harga), productUnit: produk.satuan ?? "")
                                    })
                                    .sheet(isPresented: self.$showDetailProduct, content: {
                                        DetailProductView(productBarcode: productViewModel.selectedBarcodeProduk)
                                    })
                                    .padding(.horizontal)
                                    
                                }
                            }.padding(.top, 5)
                        }
                    }
                }
                .onAppear{
                    if productViewModel.getCurrentTokoIDFromUserDefault() == nil {
                        productViewModel.setCurrentTokoForFirst()
                        productViewModel.setCurrentTokoToUserDefault()
                    }else{
                        let objectTokoId = productViewModel.getCurrentTokoIDFromUserDefault()
                        productViewModel.setCurrentTokoById(objectIDString: objectTokoId!)
                    }
                    productViewModel.fetchProductFromCurrentToko()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
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
                        .shadow(color: Color("brigray"), radius: 2, x: 0, y: 0)
                        
                    })
                    .fullScreenCover(isPresented: self.$showAddProductView, content: {
                        AddProductView(showAddProductView: self.$showAddProductView)
                    })
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    VStack{
                        
                        
                        //                            HStack{
                        //
                        ////                                HStack{
                        ////                                    Text("Toko").font(.system(.caption, design: .rounded)).bold().padding(5).padding(.horizontal,8).foregroundColor(.white)
                        ////                                }     .background(
                        ////                                    Capsule()
                        ////                                        .fill(LinearGradient(
                        ////                                            colors: [Color("sunray"), Color("bistre")],
                        ////                                            startPoint: .bottomLeading,
                        ////                                            endPoint: .topTrailing
                        ////
                        ////                                        ))
                        ////                                        .shadow(color: Color("charcoal"), radius: 1, x: 1, y: 1)
                        ////                                ).offset(x: -8, y: -18)
                        ////                                .frame(alignment: .leading)
                        //
                        //                                HStack{
                        //                                    Text("Toko").font(.system(.caption, design: .rounded)).fontWeight(.bold).padding(5).padding(.horizontal,8).foregroundColor(Color.gray)
                        //                                    Spacer()
                        //                                }  .offset(x: 0, y: -18)
                        //                                .frame(alignment: .leading)
                        //
                        //                                Spacer()
                        //                            }
                        HStack{
                            VStack{
                                Text("Toko").font(.system(.caption, design: .rounded)).fontWeight(.bold).foregroundColor(Color.gray).frame(maxWidth: .infinity, alignment: .leading)
                                
                                Text(productViewModel.currentToko?.namaToko ?? "Nama Toko")
                                    .font(.system(.callout, design: .rounded)).fontWeight(.bold)
                                    .foregroundColor(Color.black).frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.trailing,5)
                                
                                Spacer()
                                
                            }.frame(maxWidth: .infinity, alignment: .leading)
                            
                        }.frame(maxWidth: .infinity, alignment: .leading)
                            .onTapGesture {
                                self.showStoreList = true
                            }
                            .fullScreenCover(isPresented: $showStoreList, content: {
                                StoreListView(showStoreList: $showStoreList)
                            })
                    }
                }
            }
            .searchable(text: self.$searchText)
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: self.searchText){ keyword in
                productViewModel.fetchProductFromCurrentToko(searchKey: keyword)
            }
            .onChange(of: self.showDetailProduct){ _ in
                productViewModel.fetchProductFromCurrentToko()
            }
            .onChange(of: self.productViewModel.products){ _ in
                productViewModel.fetchProductFromCurrentToko()
            }
            .onChange(of: self.showStoreList){ new_value in
                if(!new_value){
                    productViewModel.fetchProductFromCurrentToko()
                }
                
            }
            .onReceive(NotificationCenter.default.storeDidChangePublisher) { notification in
                processStoreChangeNotification(notification)
                productViewModel.fetchProductFromCurrentToko()
            }
            
        }.navigationViewStyle(.stack)
    }
    
    private func processStoreChangeNotification(_ notification: Notification) {
        guard let storeUUID = notification.userInfo?[UserInfoKey.storeUUID] as? String,
              storeUUID == PersistenceController.shared.privatePersistentStore.identifier else {
            return
        }
        guard let transactions = notification.userInfo?[UserInfoKey.transactions] as? [NSPersistentHistoryTransaction],
              transactions.isEmpty else {
            return
        }
        //        isPhotoShared = (PersistenceController.shared.existingShare(photo: photo) != nil)
        //        hasAnyShare = PersistenceController.shared.shareTitles().isEmpty ? false : true
    }
}

struct MainProductListView_Previews: PreviewProvider {
    static var previews: some View {
        MainProductListView()
    }
}
