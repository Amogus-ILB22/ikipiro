//
//  OnboardingDataModel.swift
//  MC2-Mindful-App
//
//  Created by Benni L M Sinaga on 05/07/22.
//

import Foundation
//<<<<<<< Updated upstream
//=======

struct OnboardingDataModel {
    var image: String
    var heading: String
    var text: String
}

extension OnboardingDataModel {
    static var data: [OnboardingDataModel] = [
        OnboardingDataModel(image: "onboarding-1", heading: "Buat Daftar Harga\n Tanpa Ribet!", text: "Anda hanya perlu memindai kode batang barang dan masukkan harga yang sesuai. Nama barang akan muncul secara otomatis!"),
        OnboardingDataModel(image: "onboarding-2", heading: "Pindai Kode\n Batang", text: "Gunakan Alat Pindai Kode Batang untuk pencarian harga yang cepat dan tepat."),
        OnboardingDataModel(image: "onboarding-3", heading: "Multi Admin &\n Sinkronisasi", text: "Hubungkan data daftar harga di perangkat anda dengan perangkat lainnya."),
       
    ]
}
//>>>>>>> Stashed changes
