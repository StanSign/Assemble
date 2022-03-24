//
//  APIModels.swift
//  Assemble
//
//  Created by 이창준 on 2022/03/21.
//

extension AssembleAPIManager {
    
    struct NewsResult: Codable {
        var statusCode: Int
        var count: Int
        var title: String
        var results: [News]
        var description: String?
    }
    
    struct News: Codable {
        var nID: Int
        var type: String
        var url: String?
        var title: String?
        var body: String?
        var thumbnail: String
    }
    
    enum contentType: String {
        case films
        case tvSeries
        case actors
        case characters
    }
    
    struct ActorResult: Codable {
        var statusCode: Int
        var title: String
        var results: [Actor]
        var description: String?
    }
    
    struct Actor: Codable {
        var aID: Int
        var aNM: String?
        var aNM_en: String
        var aHeight: String?
        var aDoB: String?
        var aDoD: String?
        var aImage: String?
    }
    
    struct FilmResult: Codable {
        var statusCode: Int
        var title: String
        var results: [Film]
        var description: String?
    }
    
    struct Film: Codable {
        var fID: Int
        var fNM: String
        var fNM_en: String
        var fUniv: String
        var fRating: String?
        var fReleaseDate: String?
        var fRunTime: String?
        var fBoxOffice: String?
        var fPlot: String?
        var fImage: String?
    }
    
    struct SearchResult: Codable {
        var statusCode: Int
        var title: String
        var results: [Search]
        var description: String
    }
    
    struct Search: Codable {
        var id: Int
        var name: String?
        var name_En: String
        var image: String?
        var type: String
    }
}
