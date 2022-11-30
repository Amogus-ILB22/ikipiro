//
//  AddProductUnit.swift
//  Ikipiro
//
//  Created by Rivaldo Fernandes on 30/11/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import Foundation
import SwiftUI

struct AddProductUnitModalView: View {
    @EnvironmentObject var productViewModel: ProductViewModel
                        
    @Environment(\.dismiss) var dismiss
    @State var newProductUnit: String = ""
  
    var body: some View {
        NavigationView{
            VStack {
                Form{
                    Section{
                        TextField("Satuan", text: self.$newProductUnit)
                    }
                }.background(Color.white)
            }.toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    Button(action: {
                       dismiss()
                    }, label: {
                        Text("Batal")
                    }).foregroundColor(.red)
                }
                ToolbarItem(placement: .navigationBarTrailing){
                    Button(action: {
                        var temp = UserDefaults.standard.array(forKey: "units") as? [String]
                        
                        temp?.append(newProductUnit)
                        
                        UserDefaults.standard.set(temp, forKey: "units")
                        
                       dismiss()
                        
                        productViewModel.satuan = temp ?? []
 
                    }, label: {
                        Text("Selesai")
                    }).foregroundColor(.green)
                }
            }
            .navigationTitle("Tambah Kategori")
            .navigationBarTitleDisplayMode(.inline)
                
        }
    }
}

struct AddProductUnitModalView_Previews: PreviewProvider {
    static var previews: some View {
        AddProductUnitModalView()
    }
}
