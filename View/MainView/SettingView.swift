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

    @State var shareTo: String = ""
  
    

    
    @State private var shareSheet: ShareSheet?
    
    @State private var nextSheet: ShareSheet?
    
    
    
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
                List{
                    
                    ForEach(tokos, id: \.self) { toko in

                        if persistenceController.sharedPersistentStore.contains(manageObject: toko) {


                        } else{
                            
                            
                                        Section{
                                            HStack(){
                                                VStack(alignment: .leading){
                                                    Image("account")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(maxWidth: 50, maxHeight: 50)
                                                }
                                                VStack(alignment: .leading){
                                                    Text(tokos.first?.namaPemilik ?? "Bu Jeki Sumatupang").font(.system(.title2, design: .rounded))
                                                    Text("Owner").font(.system(.callout, design: .rounded))
                                                }.padding(.leading, 5)
                                                
                                                Spacer()
                                            }.frame(maxWidth: .infinity)
                                        }
                            
                            
                            
                            
                            
                            VStack{
                                //                        ZStack {
                                //                            Image("card").scaledToFill()
                                //
                                //                               Text("Hello, world!")
                                //                                   .padding()
                                //                           }
                                HStack(){
                                    
                                    
                                    VStack(alignment: .trailing){
                                        
                                        Image("logoIkipiro").resizable()
                                            .aspectRatio(contentMode: .fit).frame(height: 25)
                                        
                                    }.padding(.top,10)
                                        .padding(.leading,240)
                                        .frame(maxWidth:.infinity)
                                }
                                .frame(maxWidth:.infinity)
                                
                                
                                
                                VStack(alignment:.leading){
                                    HStack(alignment: .firstTextBaseline){
                                        Text(tokos.first?.namaToko ?? "Toko Sumber Barokah").foregroundColor(.white).font(.system(.title2, design: .rounded))
                                            .fontWeight(.bold)
                                            .shadow(color: Color(hue: 1.0, saturation: 1.0, brightness: 0.001, opacity: 0.4), radius: 5, x: 0, y: 0)
                                            .padding(.bottom,5)
                                            .padding(.top, 20)
                                        
                                        Spacer()
                                        
                                    }.frame(maxWidth:.infinity)
                                }
                                Section{
                                    
                                    HStack{
                                        TextField("Tandai penerima undangan", text: $shareTo)
                                            .textFieldStyle(.roundedBorder)
                                        Button(
                                            action: {          createNewShare(toko: tokos.first!) },
                                            label: {
                                                Image(systemName: "paperplane.fill")
                                                    .foregroundColor(Color.white)
                                            }
                                        )
                                        
                                    }
                           
//                                        .modifier(TextFieldShareButton(text: $shareTo, selectedToko: toko))
                                }.padding(.bottom, 15)
                                
                                
                                VStack(alignment:.leading){
                                    HStack(alignment: .firstTextBaseline){
                                        
                                        Text( "Dibuat pada tanggal \(((tokos.first?.dibuatPada ?? Date()).formatted(date: .numeric, time: .omitted)))")
                                            .font(.system(.callout, design: .rounded))
                                            .fontWeight(.semibold).foregroundColor(.white)
                                            .shadow(color: Color(hue: 1.0, saturation: 1.0, brightness: 0.001, opacity: 0.1), radius: 5, x: 0, y: 0)
                                            .padding(.bottom,10)
                                            .padding(.leading,5)
                                        
                                        Spacer()
                                        
                                    }.frame(maxWidth:.infinity)
                                }
                                
                                
                                
                            }.frame(maxWidth: .infinity).background(Image("card")).scaledToFit()
                            
                        }
                    }
                    
                    Section(header: Text("TOKO SAYA")) {
                        
                        ForEach(tokos, id: \.self)  { toko in
                            
                            if persistenceController.sharedPersistentStore.contains(manageObject: toko) {
                            
                                
                            } else{
                                
                                HStack(){
                                    VStack(alignment: .leading){
                                        Image(systemName: "mappin.circle.fill")
                                            .resizable()
                                            .foregroundColor(Color("GreenButton"))
                                            .aspectRatio(contentMode: .fit)
                                            .frame(maxWidth: 35, maxHeight: 35)
                                    }
                                    VStack(alignment: .leading){
                                        Text(toko.namaToko ?? "Nama Toko").font(.system(.title3, design: .rounded))
                                        Text("\(((toko.dibuatPada ?? Date()).formatted(date: .numeric, time: .omitted)))").font(.system(.callout, design: .rounded)).foregroundColor(.gray)
                                        
                                    }.padding(.leading, 5)
                                    
                                    
                                    Spacer()
                                    
                                    VStack(alignment: .leading){
                                        
                                        
                                     Button(action: {
                                         
                                         persistenceController.deleteToko(toko: toko)
                                         
                                     }, label: {
                                         
                                         
                                         Image(systemName: "minus.circle.fill")
                                             .foregroundColor(Color.red)
                                     })
                                        
                                    }.padding(.leading, 5)
                                }.frame(maxWidth: .infinity)
                                
                            }
                        }
                            }
                        
                        

                    
                    Section(header: Text("TOKO BERSAMA")) {
                        
                        ForEach(tokos, id: \.self)  { toko in
                            
                            if persistenceController.sharedPersistentStore.contains(manageObject: toko) {
                            
                                HStack(){
                                    VStack(alignment: .leading){
                                        Image(systemName: "mappin.circle.fill")
                                            .resizable()
                                            .foregroundColor(.orange)
                                            .aspectRatio(contentMode: .fit)
                                            .frame(maxWidth: 35, maxHeight: 35)
                                    }
                                    VStack(alignment: .leading){
                                        Text(toko.namaToko ?? "Nama Toko").font(.system(.title3, design: .rounded))
                                        Text("\(((toko.dibuatPada ?? Date()).formatted(date: .numeric, time: .omitted)))").font(.system(.callout, design: .rounded)).foregroundColor(.gray)
                                        
                                    }.padding(.leading, 5)
                                    
                                    Spacer()
                                }.frame(maxWidth: .infinity)
                                
                            } else{
                                
          
                                
                            }
                        }

                        
                    }

                    
                        
                        HStack{
                            Text("Atur pembagian data")
                            
                            Spacer()
                    
                            Button(
                                action: {        shareSheet = .managingSharesView },
                                label: {
                                    Image(systemName: "chevron.right")
                            
                                }
                            )
                        }
                        
                    }
                    
                         
            } .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        VStack(alignment: .leading) {
                            Text("Pengaturan")
                                .font(.system(.title, design: .rounded)).fontWeight(.bold)
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
    
    
//    struct TextFieldShareButton: ViewModifier {
//        @Binding var text: String
//        let selectedToko: Toko
//
//
//        func body(content: Content) -> some View {
//            HStack {
//                content
//
//                if !text.isEmpty {
//                    Button(
//                        action: { print("awaaw") },
//                        label: {
//                            Image(systemName: "paperplane.fill")
//                                .foregroundColor(Color.white)
//                        }
//                    )
//                }
//            }.onTapGesture {
//                SettingView.createNewShare(toko: selectedToko)
//            }
//        }
//    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
