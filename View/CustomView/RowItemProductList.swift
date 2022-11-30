//
//  RowItemProductView.swift
//  Ikipiro
//
//  Created by Rivaldo Fernandes on 30/11/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import Foundation
import SwiftUI


struct RowItemProductList: View {
    var productName: String
    var productImage: String?
    var productPrice: String
    var productUnit: String

    var body: some View {
        HStack {
            
            if(productImage == nil){
                ZStack {
                    Color("biege")
                    Image(systemName: "video.slash.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color("sunray"))
                        .frame(width: 30, height: 30)
                }.frame(width: 60, height: 60)
                    .cornerRadius(10)
                    .padding(.vertical)
                .padding(.leading)
                .padding(.trailing,5)
            }else{
                Image(productImage!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                    .cornerRadius(10)
                    .padding(.vertical)
                .padding(.leading)
                .padding(.trailing,5)
            }
            
            VStack(alignment: .leading) {
                Text(productName)
                    .font(.system(.title3))
                    .foregroundColor(Color("charcoal"))
                    .padding(.bottom,3)
                HStack(spacing: 0) {
                    Text(productPrice)
                        .foregroundColor(Color("sunray"))
                        .font(.system(.body).bold())
                    Text("/\(productUnit)")
                        .foregroundColor(Color.gray)
                        .font(.system(.footnote))
                    
                }
            }
            .padding(.vertical)
            .padding(.trailing)
            
            Spacer()
        }
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(color: Color("brigray"), radius: 3, x: 0, y: 0)
    }
}

struct RowItemProductList_Previews: PreviewProvider {
    static var previews: some View {
        RowItemProductList(productName: "Botol Minum", productImage: "plus", productPrice: "5000", productUnit: "pcs")
    }
}
