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
    

    init() {
        UITabBar.appearance().barTintColor = .white
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().backgroundColor = UIColor.white
    }
    
    @AppStorage("isStart") private var isStart: Bool = false
//    @AppStorage("isBreathingIntroStarted") private var isBreathingIntroStarted: Bool = false

    
    static let sample = OnboardingDataModel.data
    
    var body: some View {
        
//        NavigationView{
   
        if isStart
//
////            && isBreathingIntroStarted
////
        {
            
            if tokos.count < 1 {
                
                
                WelcomeView()
                
            }else{
                
                
                TabView{
                    
                    ProductListView()
                        .tabItem{
                            Image(systemName: "shippingbox").renderingMode(.template)
                            Text("Produk")
                        }
                    
                    
                    Text("Hello")
                        .tabItem{
                            Image(systemName: "barcode.viewfinder").renderingMode(.template)
                            Text("Memindai")
                        }
                    
                    SettingView()
                        .tabItem{
                            Image(systemName: "person.3").renderingMode(.template)
                            Text("Pengaturan")
                        }
                    
                }
                .accentColor(Color("GreenButton"))
                
            }
        }
        else
////        if !isStart
//
        {

            OnboardingViewPure(data: ContentView.sample, doneFunction: {
                
                withAnimation{
                UserDefaults.standard.set(true, forKey: "isStart")
                }
                
            })
//        }
//
//        else if !isBreathingIntroStarted  {
//                Breathing_Intro_Screen()
//        }

        }
        
    }
}







struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
