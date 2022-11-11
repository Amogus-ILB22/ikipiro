//
//  ProductListView.swift
//  CoreDataCloudKitShare
//
//  Created by Muhammad Nur Faqqih on 11/11/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import SwiftUI

struct ProductListView: View {
    
    
    struct ProdukDataModel: Hashable {
        var nama: String
        var harga: Double
        var satuan: String
        var kategoti: String
        var kode: Int
        
    }

        static var produks: [ProdukDataModel] = [
          ProdukDataModel(nama: "Aqua 500 Ml", harga: 5000, satuan: "Unit", kategoti: "Minuman", kode: 7978471274),
          ProdukDataModel(nama: "Fruit Tea Anggur 250 Ml", harga: 6000, satuan: "Unit", kategoti: "Minuman", kode: 2142141243),
          ProdukDataModel(nama: "Indomie Goreng Ayam Bawang", harga: 3000, satuan: "Unit", kategoti: "Makanan", kode: 423231241),
          ProdukDataModel(nama: "Aqua 500 Ml", harga: 5000, satuan: "Unit", kategoti: "Minuman", kode: 7978471274),
          ProdukDataModel(nama: "Hehehe anjay", harga: 6000, satuan: "Unit", kategoti: "Minuman", kode: 2142141243),
          ProdukDataModel(nama: "Ayam goyeng", harga: 3000, satuan: "Unit", kategoti: "Makanan", kode: 423231241),
          ProdukDataModel(nama: "Kuaci Dua kelinci", harga: 5000, satuan: "Unit", kategoti: "Minuman", kode: 7978471274),
          ProdukDataModel(nama: "Anggur Merah", harga: 6000, satuan: "Unit", kategoti: "Minuman", kode: 2142141243),
          ProdukDataModel(nama: "Gigi lu gendut", harga: 3000, satuan: "Unit", kategoti: "Makanan", kode: 423231241),
          ProdukDataModel(nama: "Apaan deh", harga: 5000, satuan: "Unit", kategoti: "Minuman", kode: 7978471274),
          ProdukDataModel(nama: "Kocak sia", harga: 6000, satuan: "Unit", kategoti: "Minuman", kode: 2142141243),
          ProdukDataModel(nama: "gigi lu gendut", harga: 3000, satuan: "Unit", kategoti: "Makanan", kode: 423231241),
          
           
        ]
    
    @State private var searchText = ""
    @StateObject var tokoModel: TokoViewModel = .init()
    
        
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    if ProductListView.produks.isEmpty {
                        Text("Tap the add (+) button on the iOS app to add a Produk.").padding()
                        Spacer()
                    } else {
//                        LazyVGrid(columns: [GridItem(.adaptive(minimum: kGridCellSize.width))]) {
                        ForEach(searchResults, id: \.self) { produk in
                                    
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
                                        Text(produk.kategoti ?? "")
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
                                        Text("\(String(produk.harga) ?? "0")")
                                            .font(.system(.title3, design: .rounded))
                                            .foregroundColor(Color("GreenButton"))
                                            .fontWeight(.bold)
                                            .frame(maxWidth: .infinity,alignment: .trailing)
                                            .multilineTextAlignment(.leading)
                                        
                                        Text("/\(produk.satuan ?? "") ")
                                            .font(.system(.caption, design: .rounded))
                                            .fontWeight(.bold)
                                            .foregroundColor(Color("GreenButton"))
                                            .frame(maxWidth: .infinity,alignment: .trailing)
                                            .font(.caption)
                                        
                                    }.padding(.trailing, 5)
                                    
                                        .frame(maxWidth: UIScreen.main.bounds.width*0.3)
                                }
                                .padding()
                                .frame(width : UIScreen.main.bounds.width*18/20, alignment: .center)
                                .background(Color.white)
                            
                                .cornerRadius(10)
//                                .padding(.horizontal, 30)
//                                .padding(.vertical,3)
                                .shadow(color: Color(hue: 1.0, saturation: 1.0, brightness: 0.001, opacity: 0.1), radius: 10, x: 0, y: 0)
                                                        .padding(.bottom,5)
                        

                            }.frame(width : UIScreen.main.bounds.width*1, alignment: .center)
                         
//                                .foregroundColor(Color.gray)
                        
                            
                            
//                                    NavigationLink(destination: DetailTokoView(tokoModel: tokoModel)) {
//                                        VStack{
//                                            Text(toko.namaToko ?? "Nama Toko").foregroundColor(.white)
//                                            Text(toko.namaPemilik ?? "Nama Pemilik").foregroundColor(.white)
//
//                                        }.background(.blue)
//                                            .padding()
//                                    }
//                                        .simultaneousGesture(TapGesture().onEnded{
//                                            tokoModel.selectedToko = toko
//                                        })
                                    // gridItemView(photo: photo, itemSize: kGridCellSize)
                                }
                            
//                        }
                    }
                }
                
                Button(action: {
                    withAnimation {
//                        showFilterSheetActivity = false
//                    activityModel.loadActivities()
                    }
                }) {
                    Text("Tambah Produk")
                        .font(.system(.headline, design: .rounded))
                        .padding()
                        .frame(maxWidth: .infinity)
    //                        .border(Color.blue)
                        .foregroundColor(.white)
                        .background(Color("GreenButton"))
                        .cornerRadius(10)
    //                        .padding()
                }.padding(.horizontal)
                    .padding(.bottom,10)
            }
            .sheet(isPresented: $tokoModel.openProdukFilter, content: {
                ProductFilterByCategoryView(tokoModel: tokoModel)
            })
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { tokoModel.openProdukFilter.toggle() }) {
                        Label("", systemImage: "line.3.horizontal.decrease.circle").labelStyle(.iconOnly).foregroundColor(Color("GreenButton"))
                    }
                }
            }
            .searchable(text: $searchText)
            .navigationBarTitleDisplayMode(.inline)
             .toolbar {
                 ToolbarItem(placement: .cancellationAction) {
                     VStack(alignment: .leading) {
                         Text("Produk")
                             .font(.system(.title, design: .rounded)).fontWeight(.bold)
                           .foregroundColor(Color.black)
                           
                         
                         Spacer()
                     }
                 }
             }

        }.navigationViewStyle(.stack)
    }
    
    var searchResults: [ProductListView.ProdukDataModel] {
        if searchText.isEmpty {
            return ProductListView.produks
        } else {
            
//            let produksFiltered = ProductListView.produks.filter() {
//                let nama = $0.nama.contains(searchText)
//
//                return nama
//            }
            
            return ProductListView.produks.filter { $0.nama.contains(searchText) }
        }
    }
}

struct ProductListView_Previews: PreviewProvider {
    static var previews: some View {
        ProductListView()
    }
}
