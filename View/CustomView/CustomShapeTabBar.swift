//
//  CustomShapeTabBar.swift
//  Ikipiro
//
//  Created by Rivaldo Fernandes on 29/11/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import Foundation
import SwiftUI

struct CustomShapeTabBar: Shape {
    func path(in rect: CGRect) -> Path {
        
        let pathOut = Path { path in
            path.move(to: CGPoint(x: 25, y: 60)) //Sudut 1
            path.addLine(to: CGPoint(x: 0, y: 90)) // Sudut 1,3
            
            //Rounded Left
            path.addArc(center: CGPoint(x: 25, y: 100), radius: 40, startAngle: Angle(degrees: -90), endAngle: Angle(degrees: -180), clockwise: true)
            
            path.addLine(to: CGPoint(x: 0, y: rect.height)) // Sudut 3
            path.addLine(to: CGPoint(x: (rect.width) , y: rect.height)) // Sudut 4
            
            //Rounded Right
            path.addArc(center: CGPoint(x: (rect.width - 25), y: 100), radius: 40, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: -90), clockwise: true)
            
            path.addLine(to: CGPoint(x: (rect.width), y: 90)) // sudut 2,4
            path.addLine(to: CGPoint(x: (rect.width-25), y: 60)) // sudut 1,2
        
            
            path.addLine(to: CGPoint(x: ((rect.width/2) + 30), y: 60)) // sudut O left
            
            
            path.addArc(center: CGPoint(x: (rect.width / 2), y: (rect.height / 2)), radius: 50, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: -180), clockwise: true)
            
            path.addLine(to: CGPoint(x: ((rect.width/2) - 30), y: 60)) // sudut O right
        }
        return pathOut
    }
}
