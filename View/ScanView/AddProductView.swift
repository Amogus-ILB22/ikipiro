//
//  EditProduct.swift
//  CoreDataCloudKitShare
//
//  Created by Rivaldo Fernandes on 12/11/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

enum EditProductSection: String, CaseIterable {
    case withBarcode = "Dengan Barcode"
    case withoutBarcode = "Tanpa Barcode"
}

enum UnitProduct: String, CaseIterable {
    case kg = "Kg"
    case ons = "Ons"
    case liter = "Liter"
    case pcs = "Pcs"
    case dozen = "Lusin"
    case box = "Dus"
    case wrap = "Bungkus"
}

struct ProductResponse: Codable, Equatable {
    var id: Int
    var barcode: String
    var nama: String
}

struct AddProductView: View {
    @EnvironmentObject var productViewModel: ProductViewModel
    @State var segmentationSelection: EditProductSection = .withBarcode
    @State var productBarcode: String = ""
    @State var productName: String = ""
    @State var productPrice: String = ""
    @State var productUnit: String = ""
    @State var productDescription: String = "Deskripsi Produk"
    @State var showProductUnit = false
    @State var showScanView = false
    @Binding var showAddProductView: Bool
    
    var body: some View {
        NavigationView{
            VStack {
                Button(action: {
                    self.showScanView.toggle()
                }, label: {
                    HStack {
                        Image(systemName: "barcode.viewfinder")
                        Text("Pindai Kode Batang")
                            .font(.body)
                            .bold()
                    }.frame(maxWidth: .infinity)
                        .frame(maxHeight: 35)
                }).sheet(isPresented: self.$showScanView, content: {
                    AddBarcodeProductView(showScanView: self.$showScanView, productBarcode: self.productBarcode)
                })
                .cornerRadius(10)
                .buttonStyle(.borderedProminent)
                .foregroundColor(.white)
                .tint(Color("sunray"))
                .padding()
                
                CustomFormStack {
                    HStack() {
                        CustomTextField(fieldString: self.$productBarcode, title: "Kode Produk", asteriks: false, keyboardType: .numberPad)
                            .onChange(of: self.productBarcode){ barcode in
                                if barcode.count == 13 {
                                    Task {
                                        await productViewModel.fetchProductFromAPI(productBarcode: self.productBarcode)
                                    }
                                }
                            }
                        Spacer()
                    }
                    .padding()
                }
                .onChange(of: productViewModel.productAutocomplete){ productResponse in
                    if(productResponse != nil){
                        self.productName = productResponse?.nama ?? ""
                    }
                }
                .padding(.bottom)
                
                CustomFormStack {
                    HStack() {
                        CustomTextField(fieldString: self.$productName, title: "Nama Produk", asteriks: true)
                        Spacer()
                    }
                    .padding()
                    
                    Divider()
                    
                    HStack() {
                        CustomTextField(fieldString: self.$productPrice, title: "Harga",asteriks: true, keyboardType: .numberPad)
                        Spacer()
                    }
                    .padding()
                    
                    Divider()
                    
                    Button(action: {
                        self.showProductUnit.toggle()
                        
                    }, label: {
                        
                        HStack(spacing: 0) {
                            Text("Satuan")
                                .font(.system(.body))
                                .foregroundColor(Color("charcoal"))
                            Text("*")
                                .font(.system(.body))
                                .foregroundColor(.red)
                            Spacer()
                            if self.productUnit.isEmpty {
                                Text("Pilih Satuan")
                                    .font(.system(.body))
                                    .foregroundColor(Color("sunray"))
                                    .padding(.trailing)
                            }else{
                                Text(self.productUnit)
                                    .font(.system(.body))
                                    .foregroundColor(Color("sunray"))
                                    .padding(.trailing)
                            }
                        }
                    })
                    .fullScreenCover(isPresented: self.$showProductUnit, content: {
                        ProductUnitSelection(showProductUnit: self.$showProductUnit, productUnit: self.$productUnit)
                    })
                    .padding()
                    
                    Divider()
                    
                    TextEditor(text: self.$productDescription)
                        .padding()
                        .frame(maxHeight: 100)
                        .colorMultiply(Color("cultured"))
                    
                    Divider()
                }
                
                CustomFormStack {
                    Button(action: {}, label: {
                        VStack{
                            Image(systemName: "camera.shutter.button.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 60)
                            
                            Text("Tambah Foto")
                                .font(.system(.body))
                                .foregroundColor(.white)
                            
                        }
                        .padding(20)
                        .background(Color("sunray"))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                        .padding(30)
                    })
                    
                }.padding()
                
                Spacer()
            }
            .ignoresSafeArea(.keyboard)
            .padding()
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    Button(action: {
                        self.showAddProductView.toggle()
                    }, label: {
                        HStack{
                            Image(systemName: "chevron.left")
                                .foregroundColor(Color("sunray"))
                            Text("Kembali")
                        }
                        
                    }).foregroundColor(Color("sunray"))
                }
                ToolbarItem(placement: .navigationBarTrailing){
                    Button(action: {
                        if(!productBarcode.isEmpty && !productDescription.isEmpty && !productName.isEmpty && !productPrice.isEmpty){
                            productViewModel.addProduct(nama: productName, satuan: productUnit, harga: Double(productPrice) ?? 0, kode: Int64(productBarcode) ?? 0, deskripsi: productDescription)
                            self.showAddProductView.toggle()
                            
                            productViewModel.fetchProductFromCurrentToko()
                        }
                    }, label: {
                        Text("Simpan")
                    }).foregroundColor(Color("sunray"))
                }
            }
            .navigationTitle("Tambah Produk")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct EditProduct_Previews: PreviewProvider {
    static var previews: some View {
        AddProdukView()
    }
}

