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
    @State var openShareDataInstruction: Bool = false
    var body: some View {
            ZStack {
                Image("welcome")
                    .resizable()
                    .aspectRatio( contentMode: .fill)
                    .frame(minWidth:0, maxWidth: .infinity)
                    .opacity(0.05)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(alignment: .center){
                    

                    HStack(alignment: .center){
                        Image("welcome-message")
                            .resizable()
                            .aspectRatio( contentMode: .fit)
                            .frame(minWidth:0, maxWidth: UIScreen.main.bounds.width * 0.5 )
                    }.padding(.top, UIScreen.main.bounds.height * 0.26  )
                    Spacer()

                }
                
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
                            .fill(Color("sunray"))
                    )
                    .onTapGesture {
                        withAnimation{
                            
                            openCreateNewToko.toggle()
                        }
                    }
                    
                    Text("Klik jika sudah memiliki toko").underline().foregroundColor(Color("bistre")).font(.caption).fontWeight(.bold)
                        .onTapGesture{
                        withAnimation{
                            
                            openShareDataInstruction.toggle()
                        }
                        }.padding(.top,5)
         
                }    .padding([.leading, .trailing],16.0)
                    .padding(.bottom, UIScreen.main.bounds.height * 0.12)
                
            }.fullScreenCover(isPresented: $openCreateNewToko, content: {
                CreateNewTokoView(openCreateNewToko: $openCreateNewToko)
            })
            .sheet(isPresented: $openShareDataInstruction, content: {
                ShareDataInstructionView(openShareDataInstruction: $openShareDataInstruction)
            })
            
        
        
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
