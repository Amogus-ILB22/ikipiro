//
//  OnboardingViewPure.swift
//  MC2-Mindful-App
//
//  Created by Benni L M Sinaga on 05/07/22.
//

import SwiftUI

struct OnboardingViewPure: View {
    var data: [OnboardingDataModel]
    var doneFunction: () -> ()
    
    @State var slideGesture: CGSize = CGSize.zero
    @State var curSlideIndex = 0
    var distance: CGFloat = UIScreen.main.bounds.size.width
    



        
        var body: some View {
            ZStack {
                Color(.systemBackground).edgesIgnoringSafeArea(.all)
                
                ZStack(alignment: .center) {
                    ForEach(0..<data.count) { i in
                        
                        OnboardingStepView(data: self.data[i])
                            .offset(x: CGFloat(i) * self.distance)
                            .offset(x: self.slideGesture.width - CGFloat(self.curSlideIndex) * self.distance)
                            .animation(.spring())
                            .gesture(DragGesture().onChanged{ value in
                                self.slideGesture = value.translation
                            }
                                     
                            .onEnded{ value in
                                if self.slideGesture.width < -50 {
                                    if self.curSlideIndex < self.data.count - 1 {
                                        withAnimation {
                                            self.curSlideIndex += 1
                                        }
                                    }
                                }
                                
                                if self.slideGesture.width > 50 {
                                    if self.curSlideIndex > 0 {
                                        withAnimation {
                                            self.curSlideIndex -= 1
                                        }
                                    }
                                }
                                self.slideGesture = .zero
                            })
                        
                    }
                    
                }
                
                
                VStack {
                    
                    Spacer()
                    self.progressView()
                        .padding(.all,24.0)
                    HStack {
     
                        Button(action: nextButton) {
                            self.arrowView()
                        }
                    }
                }
                .padding(20)
            } .navigationBarTitle("")
                .navigationBarHidden(true)
    }
        
  
        
        
    func nextButton() {
        if self.curSlideIndex == self.data.count - 1 {
            return
        }
        
        if self.curSlideIndex < self.data.count - 1 {
            withAnimation {
                self.curSlideIndex += 1
            }
        }
    }
    
    func arrowView() -> some View {
        Group {
            if self.curSlideIndex == self.data.count - 1 {
                HStack(alignment: .center) {
                    Text("Mulai")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: UIScreen.main.bounds.width * 0.3, alignment: .center)
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
                doneFunction()
                        }
                }
                .padding([.leading, .trailing],16.0)

            } else {
                HStack{
                    Text("Lewati")
                        .fontWeight(.medium)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .onTapGesture {
                            
                            withAnimation{
                            UserDefaults.standard.set(true, forKey: "isStart")
                            }
                        }
                HStack {
                    Text("Selanjutnya")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding([.leading, .trailing],6.0)
                .padding(.vertical,13)
                .padding(.horizontal,13)
                .background(
                    RoundedRectangle(cornerRadius: 8.0)
                        .fill(Color("sunray"))
                )
            }
                .padding(.trailing,24)
            }
        }
    }
    
    func progressView() -> some View {
        HStack {
            ForEach(0..<data.count) { i in
                if i == curSlideIndex{
                Rectangle()
                        .frame(width: 20, height: 10)
                        .cornerRadius(10)
                        .foregroundColor(.black)
                        .padding(.horizontal,3)
                } else {
                    Circle()
                        .frame(width: 10, height: 10)
                        .foregroundColor(.gray)
                        .padding(.horizontal,3)
                    
                }
            }
        }
    }
    
    
}

//struct OnboardingViewPure_Previews: PreviewProvider {
//    static var previews: some View {
//        OnboardingViewPure()
////=======
////    var data: [OnboardingDataModel]
////    var doneFunction: () -> ()
////
////    @State var slideGesture: CGSize = CGSize.zero
////    @State var curSlideIndex = 0
////    var distance: CGFloat = UIScreen.main.bounds.size.width
////
////
////    func nextButton() {
////        if self.curSlideIndex == self.data.count - 1 {
////            doneFunction()
////            return
////        }
////
////        if self.curSlideIndex < self.data.count - 1 {
////            withAnimation {
////                self.curSlideIndex += 1
////            }
////        }
////    }
////
////    var body: some View {
////        ZStack {
////            Color(.systemBackground).edgesIgnoringSafeArea(.all)
////
////            ZStack(alignment: .center) {
////                ForEach(0..<data.count) { i in
////
////                    OnboardingStepView(data: self.data[i])
////                        .offset(x: CGFloat(i) * self.distance)
////                        .offset(x: self.slideGesture.width - CGFloat(self.curSlideIndex) * self.distance)
////                        .animation(.spring())
////                        .gesture(DragGesture().onChanged{ value in
////                            self.slideGesture = value.translation
////                        }
////
////                        .onEnded{ value in
////                            if self.slideGesture.width < -50 {
////                                if self.curSlideIndex < self.data.count - 1 {
////                                    withAnimation {
////                                        self.curSlideIndex += 1
////                                    }
////                                }
////                            }
////
////                            if self.slideGesture.width > 50 {
////                                if self.curSlideIndex > 0 {
////                                    withAnimation {
////                                        self.curSlideIndex -= 1
////                                    }
////                                }
////                            }
////                            self.slideGesture = .zero
////                        })
////
////                }
////
////            }
////
////
////            VStack {
////
////                Spacer()
////                self.progressView()
////                    .padding(.all,24.0)
////                HStack {
////
////                    Button(action: nextButton) {
////                        self.arrowView()
////                    }
////                }
////            }
////            .padding(20)
////        }
//    }
//
//}

struct OnboardingViewPure_Previews: PreviewProvider {
    static let sample = OnboardingDataModel.data
    static var previews: some View {
        OnboardingViewPure(data: sample, doneFunction: { print("done") })
    }
}
