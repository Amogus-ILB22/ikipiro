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
    @EnvironmentObject var vm: ProductViewModel
    @Environment(\.dismiss) var dismiss
    
    @State var productBarcode: String
    @State var currentProduct: Produk? = nil
    @State var showAlert: Bool = false
    @State var image: UIImage?
    @State var showAddProductView = false
    
    var body: some View {
        NavigationView{
            if(currentProduct != nil){
                VStack {
                    Divider()
                    
                    if image == nil {
                        ZStack(alignment: .center){
                            Color("biege")
                            Image("camera_slash")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 50)
                                .foregroundColor(Color("sunray"))
                        }
                        .frame(maxHeight: 200)
                        .cornerRadius(15)
                        .padding(EdgeInsets(top: 30, leading: 30, bottom: 20, trailing: 30))
                    }else{
                        Image(uiImage: image!)
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: 200)
                            .aspectRatio(contentMode: .fill)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .padding(EdgeInsets(top: 30, leading: 30, bottom: 20, trailing: 30))
                    }
                    
                    CustomFormStack {
                        HStack() {
                            Text("Kode")
                                .font(.system(.body).bold())
                                .foregroundColor(Color("charcoal"))
                            Spacer()
                            Text(String(currentProduct?.kode ?? 0))
                                .font(.system(.body))
                                .foregroundColor(Color("charcoal"))
                        }
                        .padding()
                        Divider()
                    }
                    .padding(EdgeInsets(top: 0, leading: 30, bottom: 20, trailing: 30))
                    
                    CustomFormStack {
                        HStack() {
                            Text("Nama")
                                .font(.system(.body).bold())
                                .foregroundColor(Color("charcoal"))
                            Spacer()
                            Text(String(currentProduct?.nama ?? ""))
                                .font(.system(.body))
                                .foregroundColor(Color("charcoal"))
                        }
                        .padding()
                        
                        Divider()
                        
                        HStack() {
                            Text("Harga")
                                .font(.system(.body).bold())
                                .foregroundColor(Color("charcoal"))
                            Spacer()
                            Text("\(DetailProductView.df2so(currentProduct?.harga ?? 0))/\(currentProduct?.satuan ?? "")")
                                .font(.system(.body))
                                .foregroundColor(Color("charcoal"))
                        }
                        .padding()
                        
                        Divider()
                        
                        VStack(alignment:.leading, spacing: 10) {
                            Text("Keterangan Produk :")
                                .font(.system(.body).bold())
                                .foregroundColor(Color("charcoal"))
                            Text("\(currentProduct?.deskripsi ?? "")")
                                .font(.system(.body))
                                .foregroundColor(Color("charcoal"))
                        }
                        .padding()
                    }
                    .padding(EdgeInsets(top: 0, leading: 30, bottom: 20, trailing: 30))
                    
                    Button(action: {
                        self.showAlert = true
                    }, label: {
                        HStack {
                            Image(systemName: "trash")
                            Text("Hapus Produk")
                                .font(.body)
                                .bold()
                        }.frame(maxWidth: .infinity)
                            .frame(maxHeight: 35)
                    })
                    .cornerRadius(10)
                    .buttonStyle(.borderedProminent)
                    .foregroundColor(.red)
                    .tint(.white)
                    .padding(EdgeInsets(top: 0, leading: 30, bottom: 20, trailing: 30))
                    .shadow(color: .gray, radius: 2, x: 0, y: 0)
                    .alert("Hapus Produk", isPresented: self.$showAlert, actions: {
                        Button("Ya", role: .destructive) {
                            vm.deleteProduct(product: self.currentProduct!)
                            dismiss()
                        }
                        
                        Button("Batal", role: .cancel) {
                            
                        }
                        
                    }, message: {
                        Text("Yakin ingin hapus produk ini?")
                    })
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .toolbar{
                    ToolbarItem(placement: .navigationBarLeading){
                        Button(action: {
                            dismiss()
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
                            self.showAddProductView.toggle()
                            
                        }, label: {
                            Text("Edit")
                        }).foregroundColor(Color("sunray"))
                        
                            .fullScreenCover(isPresented: self.$showAddProductView, content: {
                                EditProductView(currentProduct: self.currentProduct!, showEditProductView: self.$showAddProductView)
                            })
                    }
                }
                .navigationTitle("Info Produk")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        .onAppear{
            self.currentProduct = vm.getProduct(productBarcode: productBarcode) ?? Produk()
            if(self.currentProduct?.photo != nil){
                image = UIImage(data: (currentProduct?.photo)!)
            }
        }
        .onChange(of: self.showAddProductView){ _ in
            self.currentProduct = vm.getProduct(productBarcode: productBarcode) ?? Produk()
        }
        .onChange(of: self.currentProduct?.photo){ newValue in
            if(newValue != nil){
                image = UIImage(data: newValue!)
                
                vm.fetchProductFromCurrentToko()
            }
        }
    }
    
    static func df2so(_ price: Double) -> String{
        let numberFormatter = NumberFormatter()
        numberFormatter.groupingSeparator = "."
        numberFormatter.groupingSize = 3
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.decimalSeparator = ","
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        return "Rp " + numberFormatter.string(from: price as NSNumber)!
    }
    
}

struct DetailProductView_Previews: PreviewProvider {
    static var previews: some View {
        DetailProductView(productBarcode: "")
    }
}


