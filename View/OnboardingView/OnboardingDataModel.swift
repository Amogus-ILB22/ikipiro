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
        OnboardingDataModel(image: "onboarding-1", heading: "Daftar Harga\n Produk yang Rapih!", text: "Tersedianya tempat untuk kamu menyimpan harga dan informasi produk dalam toko kamu secara jelas dan teratur."),
        OnboardingDataModel(image: "onboarding-2", heading: "Informasi Harga\n Produk yang Cepat!", text: "Tersedianya fitur memindai untuk mendapatkan informasi harga produk hanya dengan memindai kode batang produk!"),
        OnboardingDataModel(image: "onboarding-3", heading: "Berikan Akses ke\n Data Produkmu!", text: "Kamu dapat memberikan akses akan semua informasi produk yang ada di toko ke admin lain yang ingin kamu berikan."),
       
    ]
}
//>>>>>>> Stashed changes
