//
//  SettingView.swift
//  CoreDataCloudKitShare
//
//  Created by Muhammad Nur Faqqih on 11/11/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import SwiftUI

struct SettingView: View {
    @State var shareTo: String = ""
    var body: some View {
        
        
        
        NavigationView{
            VStack{
                List{
                                Section{
                                    HStack(){
                                        VStack(alignment: .leading){
                                            Image("account")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(maxWidth: 50, maxHeight: 50)
                                        }
                                        VStack(alignment: .leading){
                                            Text("Bu Jeki Simatupang").font(.system(.title2, design: .rounded))
                                            Text("Owner").font(.system(.callout, design: .rounded))
                                        }.padding(.leading, 5)
                                        
                                        Spacer()
                                    }.frame(maxWidth: .infinity)
                                }
                    VStack{
//                        ZStack {
//                            Image("card").scaledToFill()
//
//                               Text("Hello, world!")
//                                   .padding()
//                           }
                        HStack(){


                            VStack(alignment: .trailing){
                                
                                Image("logoIkipiro").resizable()
                                    .aspectRatio(contentMode: .fit).frame(height: 25)
                                
                            }.padding(.top,10)
                                .padding(.leading,240)
                            .frame(maxWidth:.infinity)
                        }
                        .frame(maxWidth:.infinity)
                        
                        
                        
                        VStack(alignment:.leading){
                            HStack(alignment: .firstTextBaseline){
                                Text("Toko Sumber Berkah").foregroundColor(.white).font(.system(.title2, design: .rounded))
                                    .fontWeight(.bold)
                                    .shadow(color: Color(hue: 1.0, saturation: 1.0, brightness: 0.001, opacity: 0.4), radius: 5, x: 0, y: 0)
                                    .padding(.bottom,5)
                                    .padding(.top, 30)
                                
                                Spacer()
                                
                            }.frame(maxWidth:.infinity)
                        }
                        Section{
                            TextField("Tandai penerima undangan", text: $shareTo)
                                .textFieldStyle(.roundedBorder)
                            .modifier(TextFieldClearButton(text: $shareTo))
                        }.padding(.bottom, 15)
                        
                        
                        VStack(alignment:.leading){
                            HStack(alignment: .firstTextBaseline){
                                
                                Text("Dibuat pada tanggal 02/05/2022")   .font(.system(.caption, design:
                                        .rounded))
                                .fontWeight(.bold).foregroundColor(.white)
                                    .shadow(color: Color(hue: 1.0, saturation: 1.0, brightness: 0.001, opacity: 0.1), radius: 5, x: 0, y: 0)
                            .padding(.bottom,10)
                            .padding(.leading,5)
                        
                                Spacer()
                                
                            }.frame(maxWidth:.infinity)
                        }
                        
                        
                    
                    }.frame(maxWidth: .infinity).background(Image("card")).scaledToFit()
                            }
            } .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        VStack(alignment: .leading) {
                            Text("Pengaturan")
                                .font(.system(.title, design: .rounded)).fontWeight(.bold)
                              .foregroundColor(Color.black)
                              
                            
                            Spacer()
                        }
                    }
                }
            
        }.navigationViewStyle(.stack)
    }
    struct TextFieldClearButton: ViewModifier {
        @Binding var text: String
        
        func body(content: Content) -> some View {
            HStack {
                content
                
                if !text.isEmpty {
                    Button(
                        action: { print("awaaw") },
                        label: {
                            Image(systemName: "paperplane.fill")
                                .foregroundColor(Color.white)
                        }
                    )
                }
            }
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
