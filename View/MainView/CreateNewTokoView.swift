//
//  CreateNewTokoView.swift
//  CoreDataCloudKitShare
//
//  Created by Muhammad Nur Faqqih on 12/11/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import SwiftUI
import CoreData

struct CreateNewTokoView: View {
    
    @State var namaToko : String = ""
    @Binding var openCreateNewToko: Bool
    let persistenceController = PersistenceController.shared
    @State var namaPemilik = UserDefaults.standard.object(forKey: "ownerName") as? String ?? ""
    
    var body: some View {
        NavigationView{
            ZStack{
                Image("background-create-toko")
                    .resizable()
                    .aspectRatio( contentMode: .fill)
                    .frame(minWidth:0, maxWidth: .infinity)
                    .edgesIgnoringSafeArea(.all)
                
                
                GeometryReader { geometry in
                    VStack{

                        VStack{
                            HStack{
                                Image("store")
                                    .resizable()
                                    .aspectRatio( contentMode: .fit)
                                    .frame(maxHeight: geometry.size.height * 0.25)
                            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                                .padding(.trailing,10)
                                .padding(.bottom, -30)
                            
                        }.frame(
                            minWidth: 0,
                            maxWidth: .infinity,
                            minHeight: 0,
                            maxHeight: .infinity,
                            alignment: .topLeading
                          )
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
                .navigationBarTitle(Text(""), displayMode: .inline)
                    .navigationBarItems(leading: Button(action: {
                        openCreateNewToko.toggle()
                    }) {
                        
                        HStack(alignment: .center) {
                            
                            Image(systemName: "chevron.left").foregroundColor(Color("charcoal"))
                
                            Text("Kembali").font(.system(.callout,design: .rounded)).foregroundColor(Color("charcoal")).fontWeight(.bold)
                        }.padding([.leading, .trailing],6.0)
                            .padding(.vertical,7)
                            .padding(.horizontal,8)
                            .background(
                                Capsule()
                                    .fill(.white)
                                    .shadow(color: Color("charcoal"), radius: 1, x: 1, y: 1)
                            )
                           
                    })
            }
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

struct CreateNewTokoView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewTokoView( openCreateNewToko: .constant(false))
    }
}
