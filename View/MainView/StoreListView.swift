//
//  ProductFilterByCategoryView.swift
//  CoreDataCloudKitShare
//
//  Created by Muhammad Nur Faqqih on 11/11/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import SwiftUI
import CoreData
import CloudKit


struct StoreListView: View {
    @EnvironmentObject var productViewModel: ProductViewModel
    @Binding var showStoreList: Bool
    @State var showCreateNewToko: Bool = false
    @State var selectedToko = UserDefaults.standard.object(forKey: "selectedToko") as? String ?? ""
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.namaPemilik)],
                  animation: .default
    ) private var tokos: FetchedResults<Toko>
    
    private let persistenceController = PersistenceController.shared
    
    var body: some View {
        NavigationView{
            VStack{
                Form {
                    Section(header: Text("Toko Saya").font(.system(.callout, design: .rounded)).foregroundColor(Color("sunray")).fontWeight(.semibold)) {
                        List {
                            ForEach(tokos, id:\.self){ toko in
                                if persistenceController.sharedPersistentStore.contains(manageObject: toko) {
                                    
                                } else{
                                    Button(action: {
                                 
                                    }, label: {
                                        SelectionToko(objectID: toko.objectID.uriRepresentation().absoluteString, toko: toko, selectedToko: $selectedToko)
                                    })
                                }
                            }
                        }
                    }
                    
                    Section(header: Text("Toko Bersama").font(.system(.callout, design: .rounded)).foregroundColor(Color("sunray")).fontWeight(.semibold)) {
                        List {
                            ForEach(tokos, id:\.self){ toko in
                                if persistenceController.sharedPersistentStore.contains(manageObject: toko) {
                                    
                                    Button(action: {
        
                                    }, label: {
                                        SelectionToko(objectID: toko.objectID.uriRepresentation().absoluteString, toko: toko, selectedToko: $selectedToko)
                                    })
                                    
                                } else{
                                    
                                }
                            }
                        }
                    }
                }
//                Button(action: {
//                    withAnimation {
//                        self.showCreateNewToko.toggle()
//                    }
//                }) {
//                    Text("Buat Toko Baru")
//                        .font(.system(.headline, design: .rounded))
//                        .padding()
//                        .frame(maxWidth: .infinity)
//                        .foregroundColor(.white)
//                        .background(Color("sunray"))
//                        .cornerRadius(10)
//                }.padding(.horizontal,30)
//                    .padding(.bottom,10)
//
                Button(action: {
                    withAnimation {
                        self.showCreateNewToko.toggle()
                    }
                }, label: {
                    Text("Buat Toko Baru")
                        .font(.body)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .frame(maxHeight: 35)
                    
                }).buttonStyle(.borderedProminent)
                    .foregroundColor(.white)
                    .tint(Color("sunray"))
                    .padding()
              
            }
                .sheet(isPresented: $showCreateNewToko, content: {
                    CreateNewTokoFromSettingView(showCreateNewToko: $showCreateNewToko)
                })
            
                .navigationBarTitle(Text("Daftar Toko"), displayMode: .inline)
                .navigationBarItems(leading: Button(action: {
                    self.showStoreList.toggle()
                }) {
                    HStack{
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color("sunray"))
                        
                        Text("Kembali").foregroundColor(Color("sunray"))
                        
                    }
                })
            
        }.onReceive(NotificationCenter.default.storeDidChangePublisher) { notification in
            processStoreChangeNotification(notification)
        }
        
        
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
    
}

struct SelectionToko: View {
    let objectID: String
    let toko: Toko
    @Binding var selectedToko: String
    @EnvironmentObject var  productViewModel: ProductViewModel
    
    var body: some View {
        Button(action: {
            self.selectedToko = self.objectID
            
            UserDefaults.standard.set(selectedToko, forKey: "selectedToko")
            
            productViewModel.currentToko = productViewModel.fetchTokoByObjectID()
            print("selection toko \(productViewModel.currentToko?.namaToko ?? "gk Nampilll di selection toko")")
        }, label: {
            HStack {
                Text(toko.namaToko ?? "a").foregroundColor(.black)
                Spacer()
                if selectedToko == objectID {
                    Image(systemName: "checkmark")
                        .foregroundColor(.green)
                }
            }
            .contentShape(Rectangle())
        })
    }
}

struct StoreListView_Previews: PreviewProvider {
    static var previews: some View {
        StoreListView(showStoreList: .constant(true) ,selectedToko: "")
    }
}
