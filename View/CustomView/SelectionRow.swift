//
//  SelectionRow.swift
//  Ikipiro
//
//  Created by Rivaldo Fernandes on 30/11/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import Foundation
import SwiftUI

struct SelectionRow: View {
    let title: String
    @Binding var selectedItem: String
    
    var body: some View {
        Button(action: {
            self.selectedItem = self.title
        }, label: {
            HStack {
                Text(title).foregroundColor(.black)
                Spacer()
                if title == selectedItem {
                    Image(systemName: "checkmark")
                        .foregroundColor(Color("sunray"))
                }
            }
            .contentShape(Rectangle())
        })
    }
}
