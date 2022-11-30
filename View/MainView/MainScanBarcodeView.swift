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
    @EnvironmentObject var productViewModel: ProductViewModel
    
    @State var isTorchOn = false
    @State var cameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera , for: .video, position: .front)
    
    @State var toggleCamera = false
    @State var productBarcode: String = ""
    
    @State var showDetailProduct = false
    @State var showAddProduct = false
    @State var showAlert = false
    
    var body: some View {
        ZStack(alignment: .center) {
            
            if(self.toggleCamera){
                CodeScannerView(codeTypes: [.ean13, .ean8, .code128, .code39], scanMode: .continuous,isTorchOn: isTorchOn, videoCaptureDevice:  AVCaptureDevice.default(.builtInWideAngleCamera , for: .video, position: .front), completion: { result in
                    if case let .success(code) = result {
                        self.productBarcode = code.string
                        if productViewModel.containsProduct(productBarcode: code.string){
                            self.showDetailProduct.toggle()
                        }else{
                            self.showAlert.toggle()
                        }
                    }
                })
            }else{
                CodeScannerView(codeTypes: [.ean13, .ean8, .code128, .code39], scanMode: .continuous,isTorchOn: isTorchOn, videoCaptureDevice:  AVCaptureDevice.default(.builtInWideAngleCamera , for: .video, position: .back),
                                completion: { result in
                    if case let .success(code) = result {
                        self.productBarcode = code.string
                        if productViewModel.containsProduct(productBarcode: code.string){
                            self.showDetailProduct.toggle()
                        }else{
                            self.showAlert.toggle()
                        }
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
                    
                }.frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black.opacity(0.5))
                    .sheet(isPresented: self.$showDetailProduct, content: {
                        DetailProductView(productBarcode: self.productBarcode)
                    })
                    .sheet(isPresented: self.$showAddProduct, content: {
                        AddProductView(productBarcode: productBarcode, showAddProductView: self.$showAddProduct)
                    })
                
            }
            .alert("Kode Produk Tidak Ditemukan", isPresented: self.$showAlert, actions: {
                Button(role: .cancel){
                    self.productBarcode = ""
                } label: {
                    Text("Tidak")
                }
                
                Button {
                    self.showAddProduct.toggle()
                } label: {
                    Text("Tambah")
                }
            }, message: {
                Text("Apakah ingin menambah produk dengan kode ini?")
            })
            .onDisappear{
                self.productBarcode = ""
            }
            .onChange(of: self.showAddProduct, perform: { state in
                if state == false{
                    self.productBarcode = ""
                }
                
            })
        }
    }
}

struct MainScanBarcodeView_Previews: PreviewProvider {
    static var previews: some View {
        MainScanBarcodeView()
    }
}
