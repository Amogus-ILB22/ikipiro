//
//  ContentView.swift
//  MC2-Mindful-App
//
//  Created by Angel Ria Purnamasari on 17/06/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.namaPemilik)],
                  animation: .default
    ) private var tokos: FetchedResults<Toko>
    
    @StateObject var productViewModel = ProductViewModel()
    
    
    init() {
        UITabBar.appearance().barTintColor = .white
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().backgroundColor = UIColor.white
    }
    
    @AppStorage("isStart") private var isStart: Bool = false
    
    @AppStorage("ownerName") private var ownerName: String = ""
    
    var categories: [String] = ["Makanan","Minuman","Alat Mandi", "Bahan Masak"]
    static let sample = OnboardingDataModel.data
    
    var body: some View {
        
        NavigationView{
            
            if isStart
            {
                
                if(ownerName == ""){
                    
                    InputOwnerNameView()
                    
                    
                }else {
                    
                    if tokos.count < 1 {
                        WelcomeView()
                        
                    }else{
                        
                        
                        TabView{
                            MainProductListView()
                            //                    ProductListView()
                                .tabItem{
                                    Image(systemName: "shippingbox").renderingMode(.template)
                                    Text("Produk")
                                }
                            
                            
                            //                    MainScanBarcodeView()
                            //                    TestView()
                            MainScanBarcodeView()
                                .tabItem{
                                    Image(systemName: "barcode.viewfinder").renderingMode(.template)
                                    Text("Memindai")
                                }
                            
                            SettingView()
                                .tabItem{
                                    Image(systemName: "person.3").renderingMode(.template)
                                    Text("Pengaturan")
                                }
                            
                            TestView()
                                .tabItem{
                                    Image(systemName: "testtube.2").renderingMode(.template)
                                    Text("Test")
                                }
                                .onAppear{
                                    UserDefaults.standard.set(categories, forKey: "categories")
                                }
                            
                        }
                        .accentColor(Color("GreenButton"))
                        
                    }
                }
                
            }
            else

            {
                
                OnboardingViewPure(data: ContentView.sample, doneFunction: {
                    
                    withAnimation{
                        UserDefaults.standard.set(true, forKey: "isStart")
                    }
                    
                }).onAppear() {
                    UserDefaults.standard.set(categories, forKey: "categories")
                }

            }
            
        }
        .environmentObject(productViewModel)
        
    }
}







struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
