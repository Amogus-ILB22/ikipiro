//
//  EditProductView.swift
//  Ikipiro
//
//  Created by Rivaldo Fernandes on 30/11/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import Foundation
import SwiftUI

struct EditProductView: View {
    @EnvironmentObject var productViewModel: ProductViewModel
    @State var productBarcode: String = ""
    @State var productName: String = ""
    @State var productPrice: String = ""
    @State var productUnit: String = ""
    @State var productDescription: String = ""
    
    @State var currentProduct: Produk
    @State var showProductUnit = false
    @State var showScanView = false
    
    @Binding var showEditProductView: Bool
    
    //camera variable
    @State private var showCameraSheet: Bool = false
    @State private var showImagePicker: Bool = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @State private var image: UIImage?
    
    var body: some View {
        NavigationView{
            ScrollView{
                VStack {
                    Button(action: {
                        self.showScanView.toggle()
                    }, label: {
                        HStack {
                            Image("scan")
                            Text("Pindai Kode Batang")
                                .font(.body)
                                .bold()
                        }.frame(maxWidth: .infinity)
                            .frame(height: 35)
                    }).sheet(isPresented: self.$showScanView, content: {
                        AddBarcodeProductView(showScanView: self.$showScanView, productBarcode: self.$productBarcode)
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
                                
                                Text(self.productUnit)
                                    .font(.system(.body))
                                    .foregroundColor(Color("sunray"))
                                    .padding(.trailing)
                                
                            }
                        })
                        .fullScreenCover(isPresented: self.$showProductUnit, content: {
                            ProductUnitSelection(showProductUnit: self.$showProductUnit, productUnit: self.$productUnit)
                        })
                        .padding()
                        
                        Divider()
                        
                        TextEditor(text: self.$productDescription)
                            .padding()
                            .frame(height: 100)
                            .colorMultiply(Color("cultured"))
                        
                        Divider()
                    }
                    
                    CustomFormStack {
                        Button(action: {
                            self.showCameraSheet = true
                            
                        }, label: {
                            if image == nil {
                                VStack{
                                    Image(systemName: "camera_add")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 60)
                                    
                                    Text("Tambah Foto")
                                        .font(.system(.body))
                                        .foregroundColor(.white)
                                    
                                }
                                .padding(20)
                                .frame(height: 100)
                                .background(Color("sunray"))
                                .cornerRadius(10)
                                .foregroundColor(.white)
                                .padding()
                            }else{
                                Image(uiImage: image!)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 130)
                                    .aspectRatio(contentMode: .fill)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                            }
                            
                            
                            
                        })
                        .frame(height: 130)
                        
                    }.padding()
                        .actionSheet(isPresented: self.$showCameraSheet){
                            ActionSheet(title: Text("Tambah Photo"), message: Text("Pilih Sumber"), buttons: [
                                .default(Text("Galeri Foto")) {
                                    self.showImagePicker = true
                                    self.sourceType = .photoLibrary
                                },
                                .default(Text("Kamera")) {
                                    self.showImagePicker = true
                                    self.sourceType = .camera
                                },
                                .destructive(Text("Hapus Foto")){
                                    self.image = nil
                                },
                                .cancel()
                                //                            .cancel()
                            ])
                        }
                        .sheet(isPresented: $showImagePicker) {
                            ImagePicker(image: self.$image, isShown: self.$showImagePicker, sourceType: self.sourceType)
                        }
                    
                    Spacer()
                }
                .padding()
                .toolbar{
                    ToolbarItem(placement: .navigationBarLeading){
                        Button(action: {
                            self.showEditProductView.toggle()
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
                                productViewModel.editProduct(nama: productName, satuan: productUnit, harga: Double(productPrice) ?? 0, deskripsi: productDescription, image: productViewModel.convertImageToData(image: image), product: self.currentProduct)
                                self.showEditProductView.toggle()
                                productViewModel.fetchProductFromCurrentToko()
                            }
                        }, label: {
                            Text("Simpan")
                        }).foregroundColor(Color("sunray"))
                    }
                }
                .navigationTitle("Edit Produk")
                .navigationBarTitleDisplayMode(.inline)
                .onAppear{
                    self.productUnit = currentProduct.satuan ?? ""
                    self.productBarcode = String(currentProduct.kode)
                    self.productName = currentProduct.nama ?? ""
                    self.productPrice = String(currentProduct.harga)
                    self.productDescription = currentProduct.deskripsi ?? ""
                    
                    if(currentProduct.photo != nil){
                        image = UIImage(data: (currentProduct.photo)!)
                    }
                    
                }
            }
        }
    }
}
