//
//  BannerData.swift
//  Assemble
//
//  Created by 이창준 on 2022/04/12.
//

import Foundation

struct BannerDataList {
    let banners: [BannerData]
    
    init(banners: [BannerData] = []) {
        self.banners = banners
    }
}

struct BannerData {
    let title: String
    let subtitle: String
    let imageURL: String
    let d_day: String
    
    init(
        title: String = "",
        subtitle: String = "",
        imageURL: String = "",
        d_day: String = ""
    ) {
        self.title = title
        self.subtitle = subtitle
        self.imageURL = imageURL
        self.d_day = d_day
    }
}
