//
//  TestView.swift
//  Ikipiro
//
//  Created by Rivaldo Fernandes on 23/11/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import Foundation
import SwiftUI
import CoreData

struct TestView: View {
    @EnvironmentObject var productViewModel: ProductViewModel
    @State var owner: String = ""
    @State var tokoName : String = ""
    let persistenceController = PersistenceController.shared
    @State var selectedToko: Toko?
    
    
    var body: some View {
        VStack{
            VStack(alignment: .leading, spacing: 12){
                
                TextField("Nama Anda", text: self.$owner)
                    .frame(maxWidth: .infinity)
                    .padding(.top,10)
                
                Divider()
                
                TextField("Nama Toko", text: self.$tokoName)
                    .frame(maxWidth: .infinity)
                    .padding(.top,10)
                
                Divider()
                
            }.padding(.horizontal, 30)
            
            Button(action: {
                addToko()
            }, label: {
                Text("Buat Toko Baru")
            })
            
            List{
                ForEach(productViewModel.tokos, id: \.self){ toko in
                    
                    Text(toko.namaToko ?? "")
                        .onTapGesture {
                            self.selectedToko = toko
                            productViewModel.currentToko = toko
                        }
                }
            }
            .onAppear{
                productViewModel.fetchTokos()
            }
            
            Text("Product by Toko")
            
            List {
                if selectedToko != nil {
                    ForEach(productViewModel.fetchProductInToko(toko: self.selectedToko!), id: \.self){ produk in
                        Text(produk.nama ?? "")
                    }
                }
                
                
            }
            .onAppear{
                    productViewModel.fetchTokos()
                    self.selectedToko = productViewModel.tokos.first!
                    print(self.selectedToko)
            }
        }
    }
    
    private func addToko() {
        
        guard !tokoName.isEmpty else { return }
        guard !owner.isEmpty else { return }
        
        let controller = persistenceController
        
        let taskContext = controller.persistentContainer.newTaskContext()
        taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation {
                PersistenceController.shared.addToko(namaToko: tokoName, namaPemilik: owner, context: taskContext)
            }
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
