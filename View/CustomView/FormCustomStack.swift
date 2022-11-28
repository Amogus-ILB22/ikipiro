//
//  FormCustomGroup.swift
//  Ikipiro
//
//  Created by Rivaldo Fernandes on 28/11/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import SwiftUI

struct FormCustomStack<Content> : View where Content: View {
    let content: () -> Content
    
    init(@ViewBuilder _ content: @escaping () -> Content){
        self.content = content
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            content()
        }
        .frame(maxWidth: UIScreen.main.bounds.width - 60)
        .background(Color("cultured"))
        .cornerRadius(20)
    }
}
