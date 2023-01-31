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

struct AddBarcodeProductView: View {
    @State var isTorchOn = false
    @State var cameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera , for: .video, position: .front)
    @State var toggleCamera = false
    @Binding var showScanView: Bool
    @Binding var productBarcode: String
    
    var body: some View {
        
        ZStack(alignment: .center) {
            if(self.toggleCamera){
                CodeScannerView(codeTypes: [.ean13, .ean8, .code128, .code39], scanMode: .continuous,isTorchOn: isTorchOn, videoCaptureDevice:  AVCaptureDevice.default(.builtInWideAngleCamera , for: .video, position: .front),
                                completion: { result in
                    if case let .success(code) = result {
                        self.productBarcode = code.string
                        self.showScanView = false
                    }
                })
            }else{
                CodeScannerView(codeTypes: [.ean13, .ean8, .code128, .code39], scanMode: .continuous,isTorchOn: isTorchOn, videoCaptureDevice:  AVCaptureDevice.default(.builtInWideAngleCamera , for: .video, position: .back),
                                completion: { result in
                    if case let .success(code) = result {
                        self.productBarcode = code.string
                        self.showScanView = false
                    }
                })
            }
            
            VStack{
                HStack {
                    Button(action: {
                        self.showScanView.toggle()
                    }, label: {
                            Image(systemName: "chevron.left")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 20, alignment: .center)
                    })
                    .foregroundColor(.white)
                    
                    Spacer()

                    Button(action: {
                        self.isTorchOn.toggle()
                    }, label: {
                        Image(systemName: self.isTorchOn ? "bolt.fill" : "bolt.slash.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 20, alignment: .center)
                    }).disabled(self.toggleCamera)
                        .foregroundColor(.white)
                    Spacer()
                    Button(action: {
                        self.toggleCamera.toggle()
                    }, label: {
                        Image(systemName: "gobackward")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 20, alignment: .centerLastTextBaseline)
                    })
                    .foregroundColor(.white)
                }.frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black.opacity(0.5))
                Spacer()
                
                Image("rect_barcode")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.horizontal, 60)
                
                Spacer()
                Spacer()
            }
        }
        .ignoresSafeArea(.all)
    }
}

//struct ScanView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddBarcodeProductView(showScanView: .constant(true), productBarcode: .constant(""))
//    }
//}
