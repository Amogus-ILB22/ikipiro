//
//  OnboardingStepView.swift
//  MC2-Mindful-App
//
//  Created by Benni L M Sinaga on 05/07/22.
//

import SwiftUI

struct OnboardingStepView: View {
    var data: OnboardingDataModel
    
    var body: some View {
        VStack {
            Image(data.image)
                .resizable()
                .scaledToFit()
                .padding(.top, 10)
                .frame(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.width)
            
            Text(data.heading)
                .font(.system(size: 28, design: .rounded))
                .fontWeight(.semibold)
       
                .padding(.horizontal, 45)
                .padding(.bottom, 8)
                .multilineTextAlignment(.center)
                .foregroundColor(Color("bistre"))
               
            
            Text(data.text)
                .font(.system(size: 13, design: .rounded))
                .fontWeight(.semibold)
                .padding(.horizontal, 45)
                .lineSpacing(3)
                .multilineTextAlignment(.center)
                .foregroundColor(Color("charcoal"))
        }.frame(maxWidth: .infinity,maxHeight: .infinity)
            .padding(.top, -90)
    }
}

struct OnboardingStepView_Previews: PreviewProvider {
    static var data = OnboardingDataModel.data[0]
    static var previews: some View {
        OnboardingStepView(data: data)
    }
}
