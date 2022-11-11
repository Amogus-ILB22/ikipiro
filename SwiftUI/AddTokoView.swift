//
//  AddTokoView.swift
//  CoreDataCloudKitShare
//
//  Created by Muhammad Nur Faqqih on 10/11/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import SwiftUI

import CoreData

struct AddTokoView: View {
    
    @State private var namaPemilik: String = ""
    @State private var namaToko: String = ""
 
    let persistenceController = PersistenceController.shared
    
    
    var body: some View {
        VStack{
            
            TextField( "Nama Toko", text: $namaToko)
            
            TextField( "Nama Pemilik", text: $namaPemilik)
            
            
            
            Button(action: addToko) {
                Image(systemName: "plus.circle")
                    .imageScale(.large)
                    .font(.system(size: 18))
            }
            
        }
    }
    
    
    private func addToko() {
        
        guard !namaToko.isEmpty else {
            return
        }
        
        guard !namaPemilik.isEmpty else {
            return
        }
//        toggleProgress.toggle()
        
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


struct AddTokoView_Previews: PreviewProvider {
    static var previews: some View {
        AddTokoView()
    }
}
