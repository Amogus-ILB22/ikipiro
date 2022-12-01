//
//  ShareDataInstructionView.swift
//  Ikipiro
//
//  Created by Muhammad Nur Faqqih on 01/12/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import SwiftUI

struct ShareDataInstructionView: View {
    
    @Binding var openShareDataInstruction: Bool
    

    var body: some View {
        NavigationView{
            ScrollView{
                Divider()
                Spacer()
                VStack{
           
           
                    
                    Text("Untuk Mengakses Toko sebagai Admin").foregroundColor(Color("charcoal")).font(.system(.title2, design: .rounded)).bold().multilineTextAlignment(.center)
                        .padding(.bottom,20)
                    VStack{
                        HStack{
                            VStack{
                                Image("instruction-1").resizable().frame(maxWidth: 125,maxHeight: 125)
                                
                            }
                            VStack{
                                HStack{
                                    Text("Tahap 1").font(.system(.title3, design: .rounded)).bold().foregroundColor(Color("sunray"))
                                    Spacer()
                                }.padding(.bottom,1)
                                   
                                Text("Buka Aplikasi ‘Ikipiro’ pada perangkat yang berstatus owner dari toko (yang sudah menyimpan data barang).").font(.system(.callout, design: .rounded)).bold().foregroundColor(Color("charcoal")).multilineTextAlignment(.leading)
                            }
                        }
                        
                    }.padding(.trailing,10)
                        .padding(.bottom,15)
                    
                    
                    VStack{
                        HStack{
                            VStack{
                                Image("instruction-2").resizable().frame(maxWidth: 125,maxHeight: 125)
                                
                            }
                            VStack{
                                HStack{
                                    Text("Tahap 2").font(.system(.title3, design: .rounded)).bold().foregroundColor(Color("sunray"))
                                    Spacer()
                                }.padding(.bottom,1)
                                   
                                Text("Masuk ke halaman Pengaturan dan klik (kasih logo terbang) yang akan mengarahkan kamu untuk membagikan tautan ke admin lain.").font(.system(.callout, design: .rounded)).bold().foregroundColor(Color("charcoal")).multilineTextAlignment(.leading)
                            }
                        }
                        
                    }.padding(.trailing,10)
                        .padding(.bottom,15)
                    
                    VStack{
                        HStack{
                            VStack{
                                Image("instruction-3").resizable().frame(maxWidth: 125,maxHeight: 125)
                                
                            }
                            VStack{
                                HStack{
                                    Text("Tahap 3").font(.system(.title3, design: .rounded)).bold().foregroundColor(Color("sunray"))
                                    Spacer()
                                }.padding(.bottom,1)
                                   
                                Text("Kamu dapat langsung memasuki Toko melalui link yang dikirimkan!").font(.system(.callout, design: .rounded)).bold().foregroundColor(Color("charcoal")).multilineTextAlignment(.leading)
                            }
                        }
                        
                    }.padding(.trailing,10)
                        .padding(.bottom,15)
                    
                    
                    
                    Spacer()
                    
                }.padding(.horizontal,20)
                    .padding(.vertical,30)
                
            }.navigationBarTitle(Text("Akses Admin"), displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                self.openShareDataInstruction.toggle()
            }) {
                HStack{
//                    Image(systemName: "chevron.left")
//                        .foregroundColor(Color("sunray"))
//
                    Text("Kembali").foregroundColor(Color("sunray"))
                    
                }
            })
   
        }
          
        
        
    }
}

struct ShareDataInstructionView_Previews: PreviewProvider {
    static var previews: some View {
        ShareDataInstructionView(openShareDataInstruction: .constant(false))
    }
}
