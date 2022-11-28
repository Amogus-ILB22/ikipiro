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
    
    @State var namaPemilik: String = ""
    @State var namaToko : String = ""
    
    let persistenceController = PersistenceController.shared
    
    var body: some View {
        VStack{
            Spacer()
            
            VStack{
                Text("Buat Profil Toko")
                    .font(.system(.title,design: .rounded))
                    .foregroundColor(Color("GreenButton"))
                    .fontWeight(.semibold)
                    .padding(.bottom, 35)
                
                VStack(alignment: .leading, spacing: 12){
                    
                    TextField("Nama Anda", text: $namaPemilik)
                        .frame(maxWidth: .infinity)
                        .padding(.top,10)
                    
                    
                    Divider()
                    
                    
                    TextField("Nama Toko", text: $namaToko)
                        .frame(maxWidth: .infinity)
                        .padding(.top,10)
                    
                    
                    Divider()
                    
                }.padding(.horizontal, 30)
                
            }.padding(.bottom, 200)
            
            Spacer()
            
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
                    RoundedRectangle(cornerRadius: 8.0)
                        .fill(Color("GreenButton"))
                )
                .onTapGesture {
                    withAnimation{
                        
                        addToko()
                        
                    }
                }
                .padding([.leading, .trailing],16.0)
                .disabled(namaToko.isEmpty || namaPemilik.isEmpty)

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
        CreateNewTokoView()
    }
}
