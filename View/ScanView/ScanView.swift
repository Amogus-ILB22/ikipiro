//
//  ScanView.swift
//  CoreDataCloudKitShare
//
//  Created by Rivaldo Fernandes on 12/11/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import Foundation
import SwiftUI
import AVFoundation
import CodeScanner

struct ScanView: View {
    @State var isTorchOn = false
    @State var scannedCode = "12345678910"
    @State var cameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera , for: .video, position: .front)
    @State var toggleCamera = false
    @State var showDetailProduct = false
    
    @ObservedObject var tokoViewModel: TokoViewModel = TokoViewModel()
    
    var body: some View {
        
        
        ZStack(alignment: .center) {
            if(self.toggleCamera){
                CodeScannerView(codeTypes: [.ean13, .ean8, .code128, .code39], scanMode: .continuous,isTorchOn: isTorchOn, videoCaptureDevice:  AVCaptureDevice.default(.builtInWideAngleCamera , for: .video, position: .front),
                                completion: { result in
                    if case let .success(code) = result {
                        self.scannedCode = code.string
                        tokoViewModel.currentBarcodeProduct = code.string
                    }
                })
            }else{
                CodeScannerView(codeTypes: [.ean13, .ean8, .code128, .code39], scanMode: .continuous,isTorchOn: isTorchOn, videoCaptureDevice:  AVCaptureDevice.default(.builtInWideAngleCamera , for: .video, position: .back),
                                completion: { result in
                    if case let .success(code) = result {
                        self.scannedCode = code.string
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
                
                Text(self.scannedCode)
                    .font(.system(.title3)).bold()
                    .foregroundColor(.white)
                
                Spacer()
                
                HStack{
                    Button(action: {
                        if !self.scannedCode.isEmpty{
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
                        DetailProductView(tokoViewModel: tokoViewModel, barcodeNumber: self.$scannedCode)
                    })
                
            }
        }
        
        
        
    }
}

struct ScanView_Previews: PreviewProvider {
    static var previews: some View {
        ScanView()
    }
}
