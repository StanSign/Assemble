//
//  ObjectMapper.swift
//  Assemble
//
//  Created by 이창준 on 2022/03/01.
//

import ObjectMapper

class FilmResponse: Mappable {
    var statusCode: String?
    var results: [FilmResult]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        statusCode <- map["statusCode"]
        results <- map["results"]
    }
}

class FilmResult: Mappable {
    var fID: Int?
    var fNM: String?
    var fNM_en: String?
    var fUniv: String?
    var fRating: String?
    var fReleaseDate: String?
    var fRunTime: String?
    var fBoxOffice: String?
    var fPlot: String?
    var fImage: String?
    var lastUpdate: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        fID <- map["fID"]
        fNM <- map["fNM"]
        fNM_en <- map["fNM_en"]
        fUniv <- map["fUniv"]
        fRating <- map["fRating"]
        fReleaseDate <- map["fReleaseDate"]
        fRunTime <- map["fRunTime"]
        fBoxOffice <- map["fBoxOffice"]
        fPlot <- map["fPlot"]
        fImage <- map["fImage"]
        lastUpdate <- map["lastUpdate"]
    }
}
