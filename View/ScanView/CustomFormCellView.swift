//
//  CustomFormCellView.swift
//  Ikipiro
//
//  Created by Rivaldo Fernandes on 28/11/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import SwiftUI


struct CustomFormCellView: View {
    @State var productBarcode = ""
    
    var body: some View {
        
        
        FormCustomStack{
            HStack() {
                TextField("Kode", text: self.$productBarcode)
                    .keyboardType(.numberPad)
                
                Spacer()
                Text("Hello")
            }
            .padding()
            Divider()
            HStack() {
                Text("Nama Produk").font(.system(.body))
            }
            .padding()
            Divider()
            HStack() {
                Text("Nama Produk").font(.system(.body))
            }
            .padding()
        }
    }
}

struct CustomFormCellView_Previews: PreviewProvider {
    static var previews: some View {
        CustomFormCellView()
    }
}
