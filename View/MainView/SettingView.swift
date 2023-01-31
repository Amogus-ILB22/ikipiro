//
//  SettingView.swift
//  CoreDataCloudKitShare
//
//  Created by Muhammad Nur Faqqih on 11/11/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import SwiftUI
import CoreData
import CloudKit

enum ShareSheet: Identifiable, Equatable {
    case cloudSharingSheet(CKShare)
    case managingSharesView
    case participantView(CKShare)
    
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


struct SettingView: View {
    @EnvironmentObject var productViewModel: ProductViewModel
    @State var shareTo: String = ""
    @State var toko: Toko?
    @State private var showStoreList: Bool = false
    
    @State private var shareSheet: ShareSheet?
    
    @State private var nextSheet: ShareSheet?
    @State var namaPemilik = UserDefaults.standard.object(forKey: "ownerName") as? String ?? ""
    
    @State var openShare: Bool = false
    @State var openManageShare: Bool = false
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.namaPemilik)],
                  animation: .default
    ) private var tokos: FetchedResults<Toko>
    
    private let persistenceController = PersistenceController.shared
    
    
    var body: some View {
        NavigationView{
            VStack{
                Divider()
                VStack{
                    HStack{
                        
                        Text("Hi,\(namaPemilik)!").font(.system(.title3, design: .rounded)).fontWeight(.bold)
                        Spacer()
                    }.padding(.bottom,10)
                    
      
                    
                    Button(action: {
                        withAnimation{  showStoreList.toggle()   }
                    }, label: {
                        HStack {
                            VStack(alignment: .leading){
                                Image("store-icon-fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxWidth: 50, maxHeight: 50)
                            }

                            VStack(alignment: .leading){
                                Text(productViewModel.currentToko?.namaToko ?? "").font(.system(.title2, design: .rounded)).foregroundColor(Color("charcoal"))
                                //                                                    Text("Owner").font(.system(.callout, design: .rounded))
                            }.padding(.leading, 5)

                            Spacer()

                            Button(
                                action: {   showStoreList.toggle()  },
                                label: {
                                    Image(systemName: "chevron.right").foregroundColor(Color("charcoal"))

                                }
                            )

                        }.frame(maxWidth: .infinity,maxHeight: 60)
                        

                    })
                    .cornerRadius(10)
                    .buttonStyle(.borderedProminent)
                    .foregroundColor(.white)
                    .tint(Color.white)
                    .shadow(color: .gray, radius: 1, x: 0, y: 1)
                    .padding(.vertical,5)
              
                    
                    
                    if persistenceController.sharedPersistentStore.contains(manageObject: productViewModel.currentToko ?? Toko()) {

                    } else{
                        
                        Button(action: {
                            withAnimation{ createNewShare(toko: productViewModel.currentToko!) }
                        }, label: {
                            HStack {
                                Image(systemName: "paperplane.fill")
                                Text("Kirim Akses ke Admin Lain")
                                    .font(.body)
                                    .bold()
                            }.frame(maxWidth: .infinity)
                                .frame(maxHeight: 35)
                        })
                        .cornerRadius(10)
                        .buttonStyle(.borderedProminent)
                        .foregroundColor(.white)
                        .tint(Color("sunray"))
                        .shadow(color: .gray, radius: 1, x: 0, y: 1)
                        .padding(.vertical,3)
                        
                    }
                    
                    Button(action: {
                        withAnimation{   shareSheet = .managingSharesView }
                    }, label: {
                        HStack {
                            Text("Pengaturan Data").foregroundColor(Color("charcoal"))

                                                    Spacer()
                            
                                                    
                                                            Image(systemName: "chevron.right").foregroundColor(Color("charcoal"))
                            
                                                      
                        }.frame(maxWidth: .infinity)
                            .frame(maxHeight: 35)

                    })
                    .cornerRadius(10)
                    .buttonStyle(.borderedProminent)
                    .foregroundColor(.white)
                    .tint(Color.white)
                    .shadow(color: .gray, radius: 1, x: 0, y: 1)
                    .padding(.vertical,5)
                    
//
//                    HStack{
//                        Text("Pengaturan Data").foregroundColor(Color("charcoal"))
//
//                        Spacer()
//
//                        Button(
//                            action: {     withAnimation{   shareSheet = .managingSharesView }},
//                            label: {
//                                Image(systemName: "chevron.right").foregroundColor(Color("charcoal"))
//
//                            }
//                        )
//                    }.frame(maxWidth: .infinity)
//
//                        .padding(.all,15)
//                        .background(
//                            RoundedRectangle(cornerRadius: 8.0)
//                                .fill(Color.white)
//                        )
//                        .padding(.vertical,5)
//
                }.padding(.top,20).padding(.horizontal, 30)
                
                Spacer()
                
                
                
            }.frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.listHeaderBackground)
                .fullScreenCover(isPresented: $showStoreList, content: {
                    StoreListView(showStoreList: $showStoreList)
                })
                .onAppear{
//                    productViewModel.currentToko = productViewModel.fetchTokoByObjectID()
                    if productViewModel.getCurrentTokoIDFromUserDefault() == nil {
                        productViewModel.setCurrentTokoForFirst()
                        productViewModel.setCurrentTokoToUserDefault()
                    }else{
                        let objectTokoId = productViewModel.getCurrentTokoIDFromUserDefault()
                        productViewModel.setCurrentTokoById(objectIDString: objectTokoId!)
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        VStack(alignment: .leading) {
                            Text("Pengaturan")
                                .font(.system(.largeTitle, design: .rounded)).fontWeight(.bold)
                                .foregroundColor(Color.black)
                            
                            Spacer()
                        }
                    }
                }
            
        }.onReceive(NotificationCenter.default.storeDidChangePublisher) { notification in
            processStoreChangeNotification(notification)
        }

        
        .navigationViewStyle(.stack)
        .sheet(item: $shareSheet, onDismiss: sheetOnDismiss) { item in
            sheetView(with: item)
        }
    }
    
    
    private func createNewShare(toko: Toko) {
        
        PersistenceController.shared.presentCloudSharingController(toko: toko, name: shareTo)
        
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
    private func sheetView(with item: ShareSheet) -> some View {
        switch item {
            
        case .cloudSharingSheet(_):
            /**
             Reserve this case for something like CloudSharingSheet(activeSheet: $activeSheet, share: share).
             */
            EmptyView()
            
            
        case .managingSharesView:
            ManagingSharesView(activeSheet: $shareSheet, nextSheet: $nextSheet)
        case .participantView(let share):
            
            ParticipantView(activeSheet: $shareSheet, share: share)
            
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
                shareSheet = nextActiveSheet
            }
        }
        nextSheet = nil
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
