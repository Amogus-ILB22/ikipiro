//
//  MainScanBarcodeView.swift
//  Ikipiro
//
//  Created by Rivaldo Fernandes on 13/11/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import Foundation
import SwiftUI
import CodeScanner
import AVFoundation

struct MainScanBarcodeView: View {
    @State var isTorchOn = false
    @State var cameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera , for: .video, position: .front)
    @State var toggleCamera = false
    @State var showDetailProduct = false
    
    @State var productBarcode: String = "0000"
    
    var body: some View {
        
        
        ZStack(alignment: .center) {
            if(self.toggleCamera){
                CodeScannerView(codeTypes: [.ean13, .ean8, .code128, .code39], scanMode: .continuous,isTorchOn: isTorchOn, videoCaptureDevice:  AVCaptureDevice.default(.builtInWideAngleCamera , for: .video, position: .front),
                                completion: { result in
                    if case let .success(code) = result {
                        self.productBarcode = code.string
                    }
                })
            }else{
                CodeScannerView(codeTypes: [.ean13, .ean8, .code128, .code39], scanMode: .continuous,isTorchOn: isTorchOn, videoCaptureDevice:  AVCaptureDevice.default(.builtInWideAngleCamera , for: .video, position: .back),
                                completion: { result in
                    if case let .success(code) = result {
                        self.productBarcode = code.string
                    }
                })
            }
            
            VStack{
                HStack {
                    Spacer()
                    Button(action: {
                        self.isTorchOn.toggle()
                    }, label: {
                        Image(systemName: self.isTorchOn ? "bolt.fill" : "bolt.slash.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 30, alignment: .center)
                    }).disabled(self.toggleCamera)
                        .foregroundColor(.white)
                    Spacer()
                    Button(action: {
                        self.toggleCamera.toggle()
                    }, label: {
                        Image(systemName: "gobackward")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 30, alignment: .centerLastTextBaseline)
                    })
                    .foregroundColor(.white)
                }.frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black.opacity(0.5))
                Spacer()
                Spacer()
                
                Image("rect_barcode")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.horizontal, 60)
                
                
                Spacer()
                
                Text(self.productBarcode)
                    .font(.system(.title3)).bold()
                    .foregroundColor(.white)
                
                Spacer()
                
                HStack{
                    Button(action: {
                        if !self.productBarcode.isEmpty{
                            self.showDetailProduct.toggle()
                        }
                    }, label: {
                        Color.white
                            .frame(width: 50,height: 50)
                            .clipShape(Circle())
                    })
                }.frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black.opacity(0.5))
                    .sheet(isPresented: self.$showDetailProduct, content: {
                        DetailProductView(productBarcode: self.productBarcode)
                    })
                
            }
        }
        
        
        
    }
}

struct MainScanBarcodeView_Previews: PreviewProvider {
    static var previews: some View {
        MainScanBarcodeView()
    }
}
