//
//  AddProductView.swift
//  CoreDataCloudKitShare
//
//  Created by Muhammad Nur Faqqih on 11/11/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import SwiftUI
import CoreData

struct AddProdukView: View {
    
    
    @State var nama: String = ""
    @State var deskripsi: String = ""
    @State var satuan: String = ""
    @State var kode: Double = 0
    @State var harga: Double = 0
    
    let persistenceController = PersistenceController.shared
    
       
//    let controller = persistenceController
//
    @ObservedObject var tokoModel: TokoViewModel = TokoViewModel()
//
//    let taskContext = controller.persistentContainer.newTaskContext()
//    taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    
    /// Callback after user selects to add contact with given name and phone number.
    /// Callback after user cancels.
//    let onCancel: (() -> Void)?

    var body: some View {

            VStack {
                TextField("Nama", text: $nama)
                    .textContentType(.name).padding()
                TextField("Harga", value:  $harga, formatter: NumberFormatter())
                    .keyboardType(.numberPad).padding()
                TextField("deskripsi", text: $deskripsi).padding()
                TextField("kode", value: $kode, formatter: NumberFormatter() )             .keyboardType(.numberPad).padding()
                TextField("satuan", text: $satuan).padding()

                
                Spacer()
                
                Button("Save", action: { addProduk()
                })
                    .disabled(nama.isEmpty || harga.isZero  || satuan.isEmpty  || deskripsi.isEmpty || kode.isZero)
                
            }
            .padding()
        

//            .toolbar {
//                ToolbarItem(placement: .cancellationAction) {
//                    Button("Cancel", action: { onCancel?() })
//                }
//                ToolbarItem(placement: .confirmationAction) {
//                    Button("Save", action: { print("wada")   })
//                        .disabled(nama.isEmpty || harga.isEmpty  || satuan.isEmpty  || deskripsi.isEmpty  || kode.isEmpty)
//                }
//            }
        }
    
    private func addProduk() {
        
//        toggleProgress.toggle()
        
        let controller = persistenceController
        
        let taskContext = controller.persistentContainer.newTaskContext()
        taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation {
//                PersistenceController.shared.addProduk(nama: nama, satuan: satuan, harga: harga, kode: Int64(kode), deskripsi: deskripsi,relateTo: tokoModel.selectedToko)
                   
                   tokoModel.openAddProduk.toggle()
              
            }
        }
    }
    
}

//struct AddProductView_Previews: PreviewProvider {
//    static var previews: some View {
////        AddProductView()
//    }
//}
