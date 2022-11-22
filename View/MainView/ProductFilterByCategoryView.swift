//
//  ProductFilterByCategoryView.swift
//  CoreDataCloudKitShare
//
//  Created by Muhammad Nur Faqqih on 11/11/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import SwiftUI

struct ProductFilterByCategoryView: View {
    @Binding var showProductFilter: Bool
    @Binding var selectedItem: String
    @State var categories = UserDefaults.standard.array(forKey: "categories") as? [String]

 
    var body: some View {
        NavigationView{
            VStack{
                Form {
                    List {
                        ForEach(categories ?? [], id:\.self){ category in
                            Button(action: {}, label: {
                                SelectionRow(title: category, selectedItem: self.$selectedItem)
                            })
                        }
                    }
                }
                Button(action: {
                    withAnimation {
                        self.showProductFilter.toggle()
                    }
                }) {
                    Text("Terapkan")
                        .font(.system(.headline, design: .rounded))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .background(Color("GreenButton"))
                        .cornerRadius(10)
                }.padding(.horizontal,30)
                    .padding(.bottom,10)
                
            }.background(Color.listHeaderBackground)
                .onAppear{
                    UITableView.appearance().separatorStyle = .none
                    UITableViewCell.appearance().backgroundColor = .green
                    UITableView.appearance().backgroundColor = .green
                }
            
            
            .navigationBarTitle(Text("Filter"), displayMode: .inline)
                .navigationBarItems(leading: Button(action: {
                    self.showProductFilter.toggle()
                }) {
                    Text("Kembali").foregroundColor(Color("GreenButton"))
                })
                .navigationBarItems(trailing: Button(action: {
                    print("Dismissing sheet view...")
                }) {
                    Text("Atur Ulang").foregroundColor(Color("GreenButton")).bold()
                        .onTapGesture {
                            withAnimation{
                                self.selectedItem = ""
                            }
                        }
                })
            
    
            
        }

    }
}

struct ProductFilterByCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        ProductFilterByCategoryView(showProductFilter: .constant(true) ,selectedItem: .constant(""))
    }
}
