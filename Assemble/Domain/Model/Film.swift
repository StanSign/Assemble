//
//  Film.swift
//  Assemble
//
//  Created by 이창준 on 2022/04/06.
//

import Foundation

struct Film {
    let fID: Int
    let fNM: String
    let fNM_en: String
    let fUniv: String
    let fRating: String
    let fReleaseDate: String
    let fRunTime: String
    let fBoxOffice: String
    let fPlot: String
    let fImage: String
    
    init(
        fID: Int = 0,
        fNM: String = "",
        fNM_en: String = "",
        fUniv: String = "",
        fRating: String = "",
        fReleaseDate: String = "",
        fRunTime: String = "",
        fBoxOffice: String = "",
        fPlot: String = "",
        fImage: String = ""
    ) {
        self.fID = fID
        self.fNM = fNM
        self.fNM_en = fNM_en
        self.fUniv = fUniv
        self.fRating = fRating
        self.fReleaseDate = fReleaseDate
        self.fRunTime = fRunTime
        self.fBoxOffice = fBoxOffice
        self.fPlot = fPlot
        self.fImage = fImage
    }
}
