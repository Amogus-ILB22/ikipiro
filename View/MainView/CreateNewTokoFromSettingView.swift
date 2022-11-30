//
//  CreateNewTokoView.swift
//  CoreDataCloudKitShare
//
//  Created by Muhammad Nur Faqqih on 12/11/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import SwiftUI
import CoreData

struct CreateNewTokoFromSettingView: View {
    
    @Binding var showCreateNewToko: Bool
    
    @State var namaToko : String = ""

    let persistenceController = PersistenceController.shared
    @State var namaPemilik = UserDefaults.standard.object(forKey: "ownerName") as? String ?? ""
    
    var body: some View {
        NavigationView{
            VStack{
                
                GeometryReader { geometry in
                    VStack{

                        VStack{
                            
                            VStack{
                                VStack{
                                    Text("Buat Toko")
                                        .font(.system(.title,design: .rounded))
                                        .foregroundColor(Color("bistre"))
                                        .fontWeight(.semibold)
                                        .padding(.bottom, 35)
                                    
                                    VStack(alignment: .leading, spacing: 12){
                                        
                                        
                                        TextField("Nama Toko", text: $namaToko)
                                            .frame(maxWidth: .infinity)
                                            .foregroundColor(Color("charcoal"))
                                        
                                        Divider().overlay(Color("bistre"))
                                        
                                    }.padding(.all, 30)
                                    
                                }.padding(.vertical,50)
                                
                                
                                VStack{
                                    
                                    HStack(alignment: .center) {
                                        Text("Buat")
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                            .frame(maxWidth: UIScreen.main.bounds.width * 0.53, alignment: .center)
                                    }
                                    .padding([.leading, .trailing],6.0)
                                    .padding(.vertical,13)
                                    .padding(.horizontal,13)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color("sunray"))
                                    )
                                    .onTapGesture {
                                        withAnimation{
                                            
                                            addToko()
                                            
                                            showCreateNewToko.toggle()
                                        }
                                    }                                    .padding([.leading, .trailing],16.0)
                                    .disabled(namaToko.isEmpty || namaPemilik.isEmpty)
                                    
                                    Spacer()
                                }
                            }  .frame(height: geometry.size.height * 0.73)
                        }.background(.white)

                            .frame(maxHeight:.infinity)
                        
                    }
                } .frame(maxHeight: .infinity)
            }
            .navigationBarTitle(Text("Tambah Toko"), displayMode: .inline)
                .navigationBarItems(leading: Button(action: {
                    self.showCreateNewToko.toggle()
                }) {
                    HStack{
                        
                        Text("Kembali").foregroundColor(Color("sunray"))
                        
                    }
                })
        
            
        }
        
    }
    
    private func addToko() {
        
        guard !namaToko.isEmpty else { return }
        guard !namaPemilik.isEmpty else { return }
        
        let controller = persistenceController
        
        let taskContext = controller.persistentContainer.newTaskContext()
        taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation {
                PersistenceController.shared.addToko(namaToko: namaToko, namaPemilik: namaPemilik, context: taskContext)
            }
        }
    }
}

struct CreateNewTokoFromSettingView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewTokoView( openCreateNewToko: .constant(false))
    }
}
