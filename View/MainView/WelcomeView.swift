//
//  WelcomeView.swift
//  CoreDataCloudKitShare
//
//  Created by Muhammad Nur Faqqih on 12/11/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import SwiftUI

struct WelcomeView: View {
    
    @State var openCreateNewToko: Bool = false
    var body: some View {
            ZStack {
                Image("welcome")
                    .resizable()
                    .aspectRatio( contentMode: .fill)
                    .frame(minWidth:0, maxWidth: .infinity)
                    .edgesIgnoringSafeArea(.all)
                
                
                VStack{
                    Spacer()
                    HStack(alignment: .center) {
                        Text("Buat Toko")
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
                            
                            openCreateNewToko.toggle()
                        }
                    }
                    .padding([.leading, .trailing],16.0)
                    .padding(.bottom, UIScreen.main.bounds.height * 0.25)
                }
                
            }.sheet(isPresented: $openCreateNewToko, content: {
                CreateNewTokoView()
            })
            
        
        
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
