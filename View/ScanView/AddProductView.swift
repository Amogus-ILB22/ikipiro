//
//  EditProduct.swift
//  CoreDataCloudKitShare
//
//  Created by Rivaldo Fernandes on 12/11/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import Foundation
import SwiftUI

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
    @State var productDescription: String = ""
    @State var productUnit: UnitProduct = .dozen
    @State var showCategory = false
    @State var showScanView = false
    @Binding var showAddProductView: Bool
    
    var body: some View {
        NavigationView{
            VStack {
                Form {
                    Section {
                        TextField("Nama Produk", text: self.$productName)
                        TextField("Harga", text: self.$productPrice)
                            .keyboardType(.numberPad)
                        
                        Button(action: {
                            self.showCategory.toggle()
                            
                        }, label: {
                            HStack {
                                Text("Satuan")
                                    .font(.system(.body))
                                    .foregroundColor(.black)
                                Spacer()
                                if self.productCategory.isEmpty {
                                    Text("Pilih Satuan").font(.system(.body))
                                        .foregroundColor(Color("sunray"))
                                        .padding(.trailing)
                                }else{
                                    Text(self.productCategory)
                                        .foregroundColor(Color("sunray"))
                                        .padding(.trailing)
                                }
                                
//                                Image(systemName: "chevron.right")
//                                    .foregroundColor(.gray)
                            }
                        })
                        .fullScreenCover(isPresented: self.$showCategory, content: {
                            CategorySelectionView(showCategory: self.$showCategory, productCategory: self.$productCategory)
                        })
                        
                        ZStack {
                            TextEditor(text: self.$productDescription)
                        }
                        .frame(height: 70)
                        .padding(.all, 0)
                        
                        
                    }.listRowBackground(Color.clear)
                
//                    Section {
//                        Picker("", selection: self.$productUnit){
//                            ForEach(UnitProduct.allCases, id: \.self){ unit in
//                                Text(unit.rawValue)
//                            }
//                        }.pickerStyle(.wheel)
//                            .padding(0)
//                    }.listRowBackground(Color.gray.opacity(0.1))
                    
                }
                .background(.clear)
                
                Button(action: {
                    self.showScanView.toggle()
                }, label: {
                    HStack {
                        Image(systemName: "barcode.viewfinder")
                        Text("Pindai Kode Batang")
                            .font(.body)
                    }.frame(maxWidth: .infinity)
                        .padding(.all, 0)
                }).sheet(isPresented: self.$showScanView, content: {
                    AddBarcodeProductView(showScanView: self.$showScanView, productBarcode: self.$productBarcode)
                })
                .buttonStyle(.borderedProminent)
                .foregroundColor(.white)
                .tint(Color("sunray"))
                .padding(.all, 0)
                
                Form {
                    
                            
                            Section {
                                TextField("Kode", text: self.$productBarcode)
                                    .keyboardType(.numberPad)
                            }.listRowBackground(Color.clear)
                            
                            Section {
                                HStack{
                                    Spacer()
                                    VStack(alignment: .center){
                                        Image(systemName: "camera.shutter.button.fill")
                                            .resizable()
                                            .frame(width: 50, height: 50).foregroundColor(.white)
                                        Text("Tambah Foto")
                                            .font(.system(.body).bold())
                                            .foregroundColor(.white)
                                    }
                                    .frame(width: 130,height: 130)
                                    .background(Color("sunray"))
                                    .cornerRadius(20)
                                    
                                    Spacer()
                                }
                                
                                    
                            }.listRowBackground(Color.clear)
                }
                
                
                Spacer()
            }
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    Button(action: {
                        self.showAddProductView.toggle()
                    }, label: {
                        Text("Kembali")
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
                        Text("Selesai")
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

