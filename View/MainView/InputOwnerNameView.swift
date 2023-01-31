//
//  CreateNewTokoView.swift
//  CoreDataCloudKitShare
//
//  Created by Muhammad Nur Faqqih on 12/11/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import SwiftUI
import CoreData

struct InputOwnerNameView: View {
    
    @State var namaPemilik: String = ""
    
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
                                Image("mascot-create-toko")
                                    .resizable()
                                    .aspectRatio( contentMode: .fit)
                                    .frame(maxHeight: geometry.size.height * 0.25)
                            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                                .padding(.trailing,10)
                                .padding(.bottom, -20)
                            
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
                                    Text("Hai, nama kamu siapa ?")
                                        .font(.system(.title,design: .rounded))
                                        .foregroundColor(Color("bistre"))
                                        .fontWeight(.semibold)
                                        .padding(.bottom, 35)
                                    
                                    VStack(alignment: .leading, spacing: 12){
                                        
                                        
                                        TextField("Nama", text: $namaPemilik)
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
                                            
                                            inputOwnerName()
                                            
                                        }
                                    }                                    .padding([.leading, .trailing],16.0)
                                        .disabled(namaPemilik.isEmpty)
                                    
                                    Spacer()
                                }
                            }  .frame(height: geometry.size.height * 0.73)
                        }.background(.white)
                            .frame(maxHeight:.infinity)
                        
                    }
                } .frame(maxHeight: .infinity)
                
            }
        }
        
    }
    
    private func inputOwnerName() {
        
        //        guard !namaToko.isEmpty else { return }
        
        guard !namaPemilik.isEmpty else { return }
        
        withAnimation{
            UserDefaults.standard.set(namaPemilik, forKey: "ownerName")
        }
        
        //
        //        let controller = persistenceController
        //
        //        let taskContext = controller.persistentContainer.newTaskContext()
        //        taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        //            withAnimation {
        //                PersistenceController.shared.addToko(namaToko: namaToko, namaPemilik: namaPemilik, context: taskContext)
        //            }
        //        }
        //    }
    }
}

struct InputOwnerNameView_Previews: PreviewProvider {
    static var previews: some View {
        InputOwnerNameView()
    }
}
