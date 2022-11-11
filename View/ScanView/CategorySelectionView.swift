//
//  CategorySelectionView.swift
//  CoreDataCloudKitShare
//
//  Created by Rivaldo Fernandes on 12/11/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import Foundation
import SwiftUI

struct CategorySelectionView: View {
    @State var showNewCategoryModal: Bool = false
    @State var selectedItem: String? = nil
    
    var body: some View {
        NavigationView{
            VStack {
                List {
                    ForEach((1...100), id:\.self){ number in
                        Button(action: {}, label: {
                            SelectionRow(title: "Kategori \(number)", selectedItem: self.$selectedItem)
                        })
                    }
                }
                Spacer()
                
                Button(action: {
                    self.showNewCategoryModal = true
                }, label: {
                    Text("Tambah Kategori")
                        .font(.body)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .frame(maxHeight: 35)
                    
                }).buttonStyle(.borderedProminent)
                    .foregroundColor(.white)
                    .tint(.green)
                    .padding()
                    .sheet(isPresented: self.$showNewCategoryModal, content: {
                        AddCategoryModelView()
                    })
                
            }
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    Button(action: {
                       print("clicked")
                    }, label: {
                        Text("Kembali")
                    }).foregroundColor(.green)
                }
                ToolbarItem(placement: .navigationBarTrailing){
                    Button(action: {
    //                        dismiss()
    //                        self.showEditProduct.toggle()
                       
                    }, label: {
                        Text("Selesai")
                    }).foregroundColor(.green)
                        
                }
            }
            .navigationTitle("Pilih Kategori")
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }
}

struct AddCategoryModelView: View {
    @Environment(\.dismiss) var dismiss
    @State var newCategory: String = ""
    
    var body: some View {
        NavigationView{
            VStack {
                Form{
                    Section{
                        TextField("Kategori", text: self.$newCategory)
                    }
                }.background(Color.white)
            }.toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    Button(action: {
                       dismiss()
                    }, label: {
                        Text("Batal")
                    }).foregroundColor(.red)
                }
                ToolbarItem(placement: .navigationBarTrailing){
                    Button(action: {
                       dismiss()
                    }, label: {
                        Text("Selesai")
                    }).foregroundColor(.green)
                }
            }
            .navigationTitle("Tambah Kategori")
            .navigationBarTitleDisplayMode(.inline)
                
        }
    }
}

struct SelectionRow: View {
    let title: String
    @Binding var selectedItem: String?
    
    var body: some View {
        Button(action: {
            self.selectedItem = self.title
        }, label: {
            HStack {
                Text(title)
                Spacer()
                if title == selectedItem {
                    Image(systemName: "checkmark")
                        .foregroundColor(.green)
                }
            }
            .contentShape(Rectangle())
        })
    }
}


struct CategorySelection_Previews: PreviewProvider {
    static var previews: some View {
        CategorySelectionView()
    }
}

