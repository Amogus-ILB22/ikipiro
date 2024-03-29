//
//  CustomTextField.swift
//  Ikipiro
//
//  Created by Rivaldo Fernandes on 28/11/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import Foundation
import SwiftUI

struct CustomTextField: View {
    @Binding var fieldString: String
    @State var title: String
    @State var asteriks: Bool
    @State var keyboardType: UIKeyboardType?
    
    
    
    var body: some View {
        ZStack(alignment: .leading) {
            if fieldString.isEmpty {
                
                HStack(alignment: .firstTextBaseline, spacing: 0) {
                    Text(title)
                        .font(.system(.body))
                        .foregroundColor(Color("charcoal"))
                        .padding(.all, 0)
                    if asteriks {
                        Text("*")
                            .font(.system(.body))
                            .foregroundColor(.red)
                            .padding(.all, 0)
                    }
                }
                
            }
            TextField("", text: self.$fieldString)
                .keyboardType(keyboardType ?? .default)
        }
    }
}
