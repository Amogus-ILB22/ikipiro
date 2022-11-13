//
//  DetailTokoView.swift
//  CoreDataCloudKitShare
//
//  Created by Muhammad Nur Faqqih on 10/11/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import SwiftUI
import CoreData
import CloudKit

struct DetailTokoView: View {
    
    enum ActiveSheet: Identifiable, Equatable {
        
        case cloudSharingSheet(CKShare)
        
        /**
         Use the enumeration member name string as the identifier for Identifiable.
         In the case where an enumeration has an associated value, use the label, which is equal to the member name string.
         */
        var id: String {
            let mirror = Mirror(reflecting: self)
            if let label = mirror.children.first?.label {
                return label
            } else {
                return "\(self)"
            }
        }
    }
    
    private let persistenceController = PersistenceController.shared
    
    @State private var activeSheet: ActiveSheet?
    
    @State private var nextSheet: ActiveSheet?
    
    @ObservedObject var tokoModel: TokoViewModel = TokoViewModel()
    
    @State var openShare: Bool = false
    
//    @State var openAddProduk: Bool = false
    
    var body: some View {
        VStack{
//            List{
                Text(tokoModel.selectedToko.namaToko ?? "Hhaha")
                Text(tokoModel.selectedToko.namaPemilik ?? "HEhe")
//            }
            
            
            Button("Create New Share") { createNewShare(toko: tokoModel.selectedToko) }
            
            if let produks = tokoModel.selectedToko.produk?.sortedArray(using: [NSSortDescriptor(key: "nama", ascending: true)]) as? [Produk]{
                List{
                    ForEach(produks, id: \.self) { prod in
                        
                        VStack{
                            Text(prod.nama ?? "Nama Produk").foregroundColor(.white)
                            //                        Text(prod.harga!)
                            
                        }
                    }
                }
                
            }else {
                Text("Tap the add (+) button on the iOS app to add a Toko.").padding()
                Spacer()
                
//            if tokoModel.selectedToko.produk?.count == 0 {
//                Text("Tap the add (+) button on the iOS app to add a Toko.").padding()
//                Spacer()
//            } else {
//                List{
//                    ForEach(tokoModel.selectedToko.produk, id: \.self) { prod in
//
//                        VStack{
//                            Text(prod.nama ?? "Nama Produk").foregroundColor(.white)
//                            Text(prod.kode ?? "Kode Produk").foregroundColor(.white)
//
//                        }
//                    }
//
//                    // gridItemView(photo: photo, itemSize: kGridCellSize)
//                }
//            }
            }
            //            .disabled(isPhotoShared)
            ////
            //            Button("Add to Existing Share") { activeSheet = .sharePicker(photo) }
            //            .disabled(isPhotoShared || !hasAnyShare)
            
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { tokoModel.openAddProduk.toggle() }) {
                    Label("Add Produk", systemImage: "plus").labelStyle(.iconOnly)
                }
            }
        }
        .onReceive(NotificationCenter.default.storeDidChangePublisher) { notification in
            processStoreChangeNotification(notification)
        }
        .sheet(item: $activeSheet, onDismiss: sheetOnDismiss) { item in
            sheetView(with: item)
        }
        .sheet(isPresented: $tokoModel.openAddProduk, content: {
            AddProdukView(tokoModel: tokoModel)
        })
    }
    
    private func createNewShare(toko: Toko) {
        
        PersistenceController.shared.presentCloudSharingController(toko: toko, name: "")
        openShare.toggle()
    }
    
    
    
    
    private func processStoreChangeNotification(_ notification: Notification) {
        guard let storeUUID = notification.userInfo?[UserInfoKey.storeUUID] as? String,
              storeUUID == PersistenceController.shared.privatePersistentStore.identifier else {
            return
        }
        guard let transactions = notification.userInfo?[UserInfoKey.transactions] as? [NSPersistentHistoryTransaction],
              transactions.isEmpty else {
            return
        }
        //        isPhotoShared = (PersistenceController.shared.existingShare(photo: photo) != nil)
        //        hasAnyShare = PersistenceController.shared.shareTitles().isEmpty ? false : true
    }
    
    @ViewBuilder
    private func sheetView(with item: ActiveSheet) -> some View {
        switch item {
            
        case .cloudSharingSheet(_):
            /**
             Reserve this case for something like CloudSharingSheet(activeSheet: $activeSheet, share: share).
             */
            EmptyView()
        }
        
    }
    
    private func sheetOnDismiss() {
        guard let nextActiveSheet = nextSheet else {
            return
        }
        switch nextActiveSheet {
        case .cloudSharingSheet(let share):
            DispatchQueue.main.async {
                persistenceController.presentCloudSharingController(share: share)
            }
        default:
            DispatchQueue.main.async {
                activeSheet = nextActiveSheet
            }
        }
        nextSheet = nil
    }
}
    

//struct DetailTokoView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailTokoView(currentToko: Toko)
//    }
//}
