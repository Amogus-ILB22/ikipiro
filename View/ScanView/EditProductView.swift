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
}


struct EditProductView: View {
    @State var segmentationSelection: EditProductSection = .withBarcode
    @State var productBarcode: String = ""
    @State var productName: String = ""
    @State var productPrice: String = ""
    @State var productCategory: String = ""
    @State var productUnit: UnitProduct = .dozen
    
    @State var showCategory = false
    
    var body: some View {
        NavigationView{
            VStack {
                Picker("", selection: $segmentationSelection){
                    ForEach(EditProductSection.allCases, id: \.self) { option in
                        Text(option.rawValue)
                        
                    }
                }.pickerStyle(.segmented)
                    .padding()
                
                Button(action: {}, label: {
                    HStack {
                        Image(systemName: "barcode.viewfinder")
                        Text("Scan Barcode")
                            .font(.body)
                            .bold()
                    }.frame(maxWidth: .infinity)
                        .frame(maxHeight: 35)
                }).buttonStyle(.borderedProminent)
                    .foregroundColor(.white)
                    .tint(.green)
                    .padding()
                Form {
                    Section {
                        TextField("Kode", text: self.$productBarcode)
                    }.listRowBackground(Color.gray.opacity(0.1))
                    
                    Section {
                        TextField("Nama", text: self.$productName)
                        TextField("Harga", text: self.$productPrice)
                    }.listRowBackground(Color.gray.opacity(0.1))
                    
                    Section {
                        Picker("", selection: self.$productUnit){
                            ForEach(UnitProduct.allCases, id: \.self){ unit in
                                Text(unit.rawValue)
                            }
                        }.pickerStyle(.wheel)
                    }.listRowBackground(Color.gray.opacity(0.1))
                    
                    Section {
                        Button(action: {
                            self.showCategory.toggle()
                            
                        }, label: {
                            
                            HStack {
                                Text("Kategori")
                                Spacer()
                                Text("Kategori")
                                    .padding(.trailing)
                                Image(systemName: "chevron.right")
                            }
                        })
                        .fullScreenCover(isPresented: self.$showCategory, content: {
                            CategorySelectionView()
                        })
                    }.listRowBackground(Color.gray.opacity(0.1))
                }
                .background(.clear)
    //            .scrollContentBackground(.hidden)
                
                Spacer()
            }
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    Button(action: {
                       print("clicked")
                    }, label: {
                        Text("Kembali")
                    }).foregroundColor(.green)
                }
                ToolbarItem(placement: .navigationBarTrailing){
                    Button(action: {
//                        dismiss()
//                        self.showEditProduct.toggle()
                       
                    }, label: {
                        Text("Selesai")
                    }).foregroundColor(.green)
                        
                }
            }
            .navigationTitle("Tambah Produk")
            .navigationBarTitleDisplayMode(.inline)
        }
        
        
    }
}

struct EditProduct_Previews: PreviewProvider {
    static var previews: some View {
        EditProductView()
    }
}

