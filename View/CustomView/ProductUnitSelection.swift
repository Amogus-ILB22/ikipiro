//
//  ProductUnitSelection.swift
//  Ikipiro
//
//  Created by Rivaldo Fernandes on 30/11/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import Foundation
import SwiftUI


struct ProductUnitSelection: View {
    @EnvironmentObject var productViewModel: ProductViewModel
    @State var showNewProductUnitModal: Bool = false
    
    @Binding var showProductUnit: Bool
    @Binding var productUnit: String
    
    let dummyProductUnit = ["pcs", "kg", "liter"]
    
    var body: some View {
        NavigationView{
            VStack {
                List {
                    ForEach(productViewModel.satuan ?? [], id:\.self){ productUnit in
                        SelectionRow(title: productUnit, selectedItem: self.$productUnit)
                    }
                }
                
                Spacer()
                
                Button(action: {
                    self.showNewProductUnitModal = true
                }, label: {
                    Text("Tambah Satuan")
                        .font(.body)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .frame(maxHeight: 35)
                    
                }).buttonStyle(.borderedProminent)
                    .foregroundColor(.white)
                    .tint(.green)
                    .padding()
                    .sheet(isPresented: self.$showNewProductUnitModal, content: {
                        AddProductUnitModalView()
                    })
                
            }
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    Button(action: {
                        self.showProductUnit.toggle()
                    }, label: {
                        Text("Kembali")
                    }).foregroundColor(.green)
                }
                ToolbarItem(placement: .navigationBarTrailing){
                    Button(action: {
                        if !self.productUnit.isEmpty{
                            self.showProductUnit.toggle()
                        }
                    }, label: {
                        Text("Selesai")
                    }).foregroundColor(.green)
                        
                }
            }
            .navigationTitle("Pilih Satuan")
            .navigationBarTitleDisplayMode(.inline)
        }.onAppear{
            productViewModel.satuan = UserDefaults.standard.array(forKey: "units") as? [String]
            print(productViewModel.satuan ?? "gk ada")
        }
    }
}

struct ProductUnitSelection_Previews: PreviewProvider {
    static var previews: some View {
        ProductUnitSelection(showProductUnit: .constant(true), productUnit: .constant("kg"))
    }
}
