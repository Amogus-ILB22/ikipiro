//
//  EditProductView.swift
//  Ikipiro
//
//  Created by Rivaldo Fernandes on 13/11/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import Foundation
import SwiftUI

struct EditProductView: View {
    @StateObject var productViewModel = ProductViewModel()
    
    private let persistenceController = PersistenceController.shared
    @Environment(\.managedObjectContext) private var viewContext
    @State var segmentationSelection: EditProductSection = .withBarcode
    @State var productBarcode: String = ""
    @State var productName: String = ""
    @State var productPrice: String = ""
    @State var productCategory: String = ""
    @State var productUnit: UnitProduct = .dozen
    @State var currentProduct: Produk
    
    @State var showCategory = false
    @State var showScanView = false
    
    @Binding var showAddProductView: Bool
    
    var body: some View {
        NavigationView{
            VStack {
                Picker("", selection: $segmentationSelection){
                    ForEach(EditProductSection.allCases, id: \.self) { option in
                        Text(option.rawValue)
                        
                    }
                }.pickerStyle(.segmented)
                    .padding(.horizontal)
                
                if segmentationSelection == EditProductSection.withBarcode{
                    Button(action: {
                        self.showScanView.toggle()
                    }, label: {
                        HStack {
                            Image(systemName: "barcode.viewfinder")
                            Text("Scan Barcode")
                                .font(.body)
                                .bold()
                        }.frame(maxWidth: .infinity)
                            .frame(maxHeight: 35)
                    }).sheet(isPresented: self.$showScanView, content: {
                        AddBarcodeProductView(showScanView: self.$showScanView, productBarcode: self.$productBarcode)
                    })
                    .buttonStyle(.borderedProminent)
                        .foregroundColor(.white)
                        .tint(.green)
                        .padding()
                }
                
                Form {
                    Section {
                        TextField("Kode", text: self.$productBarcode)
                            .keyboardType(.numberPad)
                    }.listRowBackground(Color.gray.opacity(0.1))
                    
                    Section {
                        TextField("Nama", text: self.$productName)
                        TextField("Harga", text: self.$productPrice)
                            .keyboardType(.numberPad)
                    }.listRowBackground(Color.gray.opacity(0.1))
                    
                    Section {
                        Picker("", selection: self.$productUnit){
                            ForEach(UnitProduct.allCases, id: \.self){ unit in
                                Text(unit.rawValue)
                            }
                        }.pickerStyle(.wheel)
                            .padding(0)
                    }.listRowBackground(Color.gray.opacity(0.1))
                    
                    Section {
                        Button(action: {
                            self.showCategory.toggle()
                            
                        }, label: {
                            
                            HStack {
                                Text("Kategori")
                                Spacer()
                                if self.productCategory.isEmpty {
                                    Text("Pilih Kategori")
                                        .padding(.trailing)
                                }else{
                                    Text(self.productCategory)
                                        .padding(.trailing)
                                }
                                    
                                Image(systemName: "chevron.right")
                            }
                        })
                        .fullScreenCover(isPresented: self.$showCategory, content: {
                            CategorySelectionView(showCategory: self.$showCategory, productCategory: self.$productCategory)
                        })
                    }.listRowBackground(Color.gray.opacity(0.1))
                }
                .background(.clear)
                Spacer()
            }
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    Button(action: {
                        self.showAddProductView.toggle()
                    }, label: {
                        Text("Kembali")
                    }).foregroundColor(.green)
                }
                ToolbarItem(placement: .navigationBarTrailing){
                    Button(action: {
                        if(!productBarcode.isEmpty && !productCategory.isEmpty && !productName.isEmpty && !productPrice.isEmpty){
                            productViewModel.editProduct(nama: self.productName, satuan: self.productUnit.rawValue, harga: Double(self.productPrice) ?? 0, kategori: self.productCategory, product: self.currentProduct)
                            
                            self.showAddProductView.toggle()
                        }
                    }, label: {
                        Text("Selesai")
                    }).foregroundColor(.green)
                        
                }
            }
            .navigationTitle("Ubah Produk")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear{
            self.productBarcode = String(currentProduct.kode)
            self.productName = currentProduct.nama ?? ""
            self.productPrice = String(currentProduct.harga)
            self.productCategory = currentProduct.kategori ?? ""
            self.productUnit = UnitProduct.init(rawValue: currentProduct.satuan ?? "")!
        }
    }
}
