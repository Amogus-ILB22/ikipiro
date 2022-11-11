//
//  ProductFilterByCategoryView.swift
//  CoreDataCloudKitShare
//
//  Created by Muhammad Nur Faqqih on 11/11/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import SwiftUI

struct ProductFilterByCategoryView: View {
    
    
//    init() {
//        UIView.appearance().backgroundColor = UIColor.red
//    }
//    
    
    @ObservedObject var tokoModel: TokoViewModel = TokoViewModel()
    
    

 
    var body: some View {
        NavigationView{
            VStack{
                Form {
                    List{
                        Text("Hello, World!")
                        Text("Hello, World!")
                        Text("Hello, World!")
                        Text("Hello, World!")
                        Text("Hello, World!")
                    }      .listRowBackground(Color.white)
                        .background(Color.white)
                    
                }
                Button(action: {
                    withAnimation {
//                        showFilterSheetActivity = false
//                    activityModel.loadActivities()
                        
                        tokoModel.openProdukFilter.toggle()
                    }
                }) {
                    Text("Terapkan")
                        .font(.system(.headline, design: .rounded))
                        .padding()
                        .frame(maxWidth: .infinity)
    //                        .border(Color.blue)
                        .foregroundColor(.white)
                        .background(Color("GreenButton"))
                        .cornerRadius(10)
    //                        .padding()
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
                    tokoModel.openProdukFilter.toggle()
                    //                self.showSheetView = false
                }) {
                    Text("Kembali").foregroundColor(Color("GreenButton"))
                })
                .navigationBarItems(trailing: Button(action: {
                    print("Dismissing sheet view...")
                    //                self.showSheetView = false
                }) {
                    Text("Atur Ulang").foregroundColor(Color("GreenButton")).bold()
                })
            
    
            
        }

    }
}

struct ProductFilterByCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        ProductFilterByCategoryView()
    }
}
