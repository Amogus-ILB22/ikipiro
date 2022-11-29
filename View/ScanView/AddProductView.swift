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

struct AddProductView: View {
    @EnvironmentObject var productViewModel: ProductViewModel
    @State var segmentationSelection: EditProductSection = .withBarcode
    @State var productBarcode: String = ""
    @State var productName: String = ""
    @State var productPrice: String = ""
    @State var productCategory: String = ""
    @State var productDescription: String = "Deskripsi Produk"
    @State var productUnit: UnitProduct = .dozen
    @State var showCategory = false
    @State var showScanView = false
    @Binding var showAddProductView: Bool
    
    var body: some View {
        NavigationView{
            VStack {
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
                        self.showCategory.toggle()
                        
                    }, label: {
                        
                        HStack(spacing: 0) {
                            Text("Satuan")
                                .font(.system(.body))
                                .foregroundColor(Color("charcoal"))
                            Text("*")
                                .font(.system(.body))
                                .foregroundColor(.red)
                            Spacer()
                            if self.productCategory.isEmpty {
                                Text("Pilih Satuan")
                                    .font(.system(.body))
                                    .foregroundColor(Color("sunray"))
                                    .padding(.trailing)
                            }else{
                                Text(self.productCategory)
                                    .padding(.trailing)
                            }
                        }
                    })
                    .fullScreenCover(isPresented: self.$showCategory, content: {
                        CategorySelectionView(showCategory: self.$showCategory, productCategory: self.$productCategory)
                    })
                    .padding()
                    
                    Divider()
                    
                    TextEditor(text: self.$productDescription)
                    .padding()
                    .frame(maxHeight: 100)
                    .colorMultiply(Color("cultured"))
                    
                    Divider()
                    
                }
                
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
                        Spacer()
                    }
                    .padding()
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
                        if(!productBarcode.isEmpty && !productCategory.isEmpty && !productName.isEmpty && !productPrice.isEmpty){
                            productViewModel.addProduct(nama: productName, satuan: productUnit.rawValue, harga: Double(productPrice) ?? 0, kode: Int64(productBarcode) ?? 0, kategori: productCategory)
                            self.showAddProductView.toggle()
                            productViewModel.filteredProduct()
                        }
                    }, label: {
                        Text("Simpan")
                    }).foregroundColor(Color("sunray"))
                }
            }
            .navigationTitle("Tambah Produk")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear{
            UITableView.appearance().backgroundColor = .clear
            UITableViewCell.appearance().backgroundColor = UIColor.clear
        }
    }
}

struct EditProduct_Previews: PreviewProvider {
    static var previews: some View {
        AddProdukView()
    }
}

