//
//  Test.swift
//  Ikipiro
//
//  Created by Rivaldo Fernandes on 21/11/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import Foundation
import SwiftUI

struct TestView: View {
    @StateObject var vm = ProductViewModel()
    
    
    var body: some View {
        List{
            ForEach(vm.products){ product in
                Text(product.nama ?? "")
            }
        }
        .onAppear{
            vm.fetchProduct()
            print(vm.containsProduct(productBarcode: "666"))
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
