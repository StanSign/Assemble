//
//  Upcoming.swift
//  Assemble
//
//  Created by 이창준 on 2022/03/03.
//

import RealmSwift
import ObjectMapper
import ObjectMapper_Realm

@objcMembers class responseFilm: Object, Mappable {
    dynamic var statusCode: String = ""
    var results: List<Upcoming> = List<Upcoming>()
    
    required convenience init?(map: ObjectMapper.Map) {
        self.init()
    }
    
    func mapping(map: ObjectMapper.Map) {
        statusCode  <- map["statusCode"]
        results     <- (map["results"], ListTransform<Upcoming>())
    }
}

@objcMembers class Upcoming: Object, Mappable {
    
    dynamic var fID: Int = 0
    dynamic var fNM: String = ""
    dynamic var fNM_en: String = ""
    dynamic var fUniv: String = ""
    dynamic var fRating: String = ""
    dynamic var fReleaseDate: String = ""
    dynamic var fRunTime: String = ""
    dynamic var fBoxOffice: String = ""
    dynamic var fPlot: String = ""
    dynamic var fImage: String = ""
    
    required convenience init?(map: ObjectMapper.Map) {
        self.init()
    }
    
    func mapping(map: ObjectMapper.Map) {
        fID             <- map["fID"]
        fNM             <- map["fNM"]
        fNM_en          <- map["fNM_en"]
        fUniv           <- map["fUniv"]
        fRating         <- map["fRating"]
        fReleaseDate    <- map["fReleaseDate"]
        fRunTime        <- map["fRunTime"]
        fBoxOffice      <- map["fBoxOffice"]
        fPlot           <- map["fPlot"]
        fImage          <- map["fImage"]
    }
    
    override class func primaryKey() -> String? {
        return "fID"
    }
}
