//
//  MainView.swift
//  Ikipiro
//
//  Created by Rivaldo Fernandes on 29/11/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import Foundation
import SwiftUI

class Theme {
    static func navigationBarColors(background : UIColor?,
       titleColor : UIColor? = nil, tintColor : UIColor? = nil ){
        
        let navigationAppearance = UINavigationBarAppearance()
        navigationAppearance.configureWithOpaqueBackground()
        navigationAppearance.backgroundColor = background ?? .clear
        navigationAppearance.shadowColor = .clear
        
        navigationAppearance.titleTextAttributes = [.foregroundColor: titleColor ?? .black]
        navigationAppearance.largeTitleTextAttributes = [.foregroundColor: titleColor ?? .black]
       
        UINavigationBar.appearance().standardAppearance = navigationAppearance
        UINavigationBar.appearance().compactAppearance = navigationAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationAppearance

        UINavigationBar.appearance().tintColor = tintColor ?? titleColor ?? .black
    }
}

struct MainView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.namaPemilik)],
                  animation: .default
    ) private var tokos: FetchedResults<Toko>
    
    @StateObject var productViewModel = ProductViewModel()
    
    @AppStorage("isStart") private var isStart: Bool = false
    @AppStorage("selectedToko") private var selectedToko: String = ""
    @AppStorage("ownerName") private var ownerName: String = ""
    
    var units: [String] = ["Pcs","Liter","Kg", "Paket"]
    static let sample = OnboardingDataModel.data
    
    @State var selectedTab: Int = 0
    
    init() {
        UITabBar.appearance().barTintColor = .white
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().backgroundColor = UIColor.white
    }
    
    
    var body: some View {
        NavigationView{
            if isStart {
                
                if(ownerName == ""){
                    
                    InputOwnerNameView()
                    
                    
                }else {
                    
                    if tokos.count < 1 {
                        WelcomeView()
                    }else{
                        ZStack {
                            VStack {
                                if selectedTab == 0 {
                                    MainProductListView()
                                        .padding(.bottom, 40)
                                }else if selectedTab == 1 {
                                    MainScanBarcodeView()
                                        .padding(.bottom, 40)
                                }else{
                                    SettingView()
                                        .padding(.bottom, 40)
                                }
                                Spacer()
                                
                            }.padding(.bottom, 40)
                            
                            VStack(spacing: 0) {
                                
                                Spacer()
                                
                                HStack {
                                    
                                    Spacer(minLength: 0)
                                    
                                    Button(action : {
                                        self.selectedTab = 0
                                    }){
                                        VStack {
                                            Image(selectedTab == 0 ? "box_active": "box_inactive")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(maxWidth: 30)
                                            Text("Produk")
                                                .font(.system(.caption, design: .rounded))
                                                .padding(.bottom, 25)
                                        }
                                        .frame(width: 100)
                                    }
                                    .foregroundColor(selectedTab == 0 ? Color.black : Color("sunray"))
                                    
                                    Spacer(minLength: 0)
                                    
                                    Button(action: {
                                        self.selectedTab = 1
                                    }){
                                        VStack {
                                            Image(selectedTab == 1 ? "barcode_active": "barcode_inactive")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(maxWidth: 35)
                                            Text("Pindai")
                                                .font(.system(.caption, design: .rounded))
                                            
                                        }
                                        .frame(width: 80, height: 80)
                                        .background(Color(selectedTab == 1 ? "sunray" : "biege"))
                                        .clipShape(Circle())
                                        
                                    }
                                    .offset(y: -28)
                                    .foregroundColor(selectedTab == 1 ? Color.black : Color("sunray"))
                                    
                                    Spacer(minLength: 0)
                                    
                                    Button(action : {
                                        self.selectedTab = 2
                                    }){
                                        VStack {
                                            Image(selectedTab == 2 ? "person_active": "person_inactive")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(maxWidth: 30)
                                            Text("Pengaturan")
                                                .font(.system(.caption, design: .rounded))
                                                .padding(.bottom, 25)
                                        }
                                        .frame(width: 100, height: 100)
                                    }
                                    .foregroundColor(selectedTab == 2 ? Color.black : Color("sunray"))
                                    
                                    Spacer(minLength: 0)
                                }
                                
                                .padding(.top, 60)
                                .background(.white)
                                .clipShape(CustomShapeTabBar())
                                .shadow(color: Color("brigray"), radius: 7, x: 0, y: 0)
                            }
                        }
                        .ignoresSafeArea(edges: .bottom)
                    }
                    
                }
            }
            else
            
            {

                OnboardingViewPure(data: MainView.sample, doneFunction: {
                    
                    withAnimation{
                        UserDefaults.standard.set(true, forKey: "isStart")
                    }
                    
                }).onAppear{
                    UserDefaults.standard.set(units, forKey: "units")
                }
                
            }
        }
        .environmentObject(productViewModel)
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
