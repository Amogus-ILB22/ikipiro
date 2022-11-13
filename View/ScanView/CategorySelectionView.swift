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
    
    @Binding var showCategory: Bool
    @Binding var productCategory: String
//    @State var categories = UserDefaults.standard.array(forKey: "categories") as? [String]
    
    @StateObject var tokoModel: TokoViewModel = .init()
    
    var body: some View {
        NavigationView{
            VStack {
                List {
                    ForEach(tokoModel.categories ?? [], id:\.self){ category in
                            SelectionRow(title: category, selectedItem: self.$productCategory)
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
                        AddCategoryModelView(tokoModel: tokoModel)
                    })
                
            }
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    Button(action: {
                        self.showCategory.toggle()
                    }, label: {
                        Text("Kembali")
                    }).foregroundColor(.green)
                }
                ToolbarItem(placement: .navigationBarTrailing){
                    Button(action: {
                        if !self.productCategory.isEmpty{
                            self.showCategory.toggle()
                        }
                    }, label: {
                        Text("Selesai")
                    }).foregroundColor(.green)
                        
                }
            }
            .navigationTitle("Pilih Kategori")
            .navigationBarTitleDisplayMode(.inline)
        }.onAppear{
            
            tokoModel.categories = UserDefaults.standard.array(forKey: "categories") as? [String]
            
        }
        
    }
}

struct AddCategoryModelView: View {
    @ObservedObject var tokoModel: TokoViewModel = TokoViewModel()
                        
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
                        var temp = UserDefaults.standard.array(forKey: "categories") as? [String]
                        
                        temp?.append(newCategory)
                        
                        
                        UserDefaults.standard.set(temp, forKey: "categories")
                        
                        
                       dismiss()
                        
                        tokoModel.categories = temp ?? []
                       
                        
                        
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
    @Binding var selectedItem: String
    
    var body: some View {
        Button(action: {
            self.selectedItem = self.title
        }, label: {
            HStack {
                Text(title).foregroundColor(.black)
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
        CategorySelectionView(showCategory: .constant(true), productCategory: .constant(""))
    }
}

