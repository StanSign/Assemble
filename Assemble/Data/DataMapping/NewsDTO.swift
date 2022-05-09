//
//  NewsDTO.swift
//  Assemble
//
//  Created by 이창준 on 2022/05/02.
//

import Foundation

struct NewsResultDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case title
        case count
        case description
        case statusCode
        case results
    }
    let title: String
    let count: Int
    let description: String?
    let statusCode: Int
    let results: [NewsDTO]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.statusCode = try container.decode(Int.self, forKey: .statusCode)
        self.title = try container.decode(String.self, forKey: .title)
        self.count = try container.decode(Int.self, forKey: .count)
        self.description = try container.decode(String.self, forKey: .description)
        self.results = try container.decode([NewsDTO].self, forKey: .results)
    }
}

extension NewsResultDTO {
    struct NewsDTO: Decodable {
        private enum CodingKeys: String, CodingKey {
            case id = "nID"
            case type
            case urlString = "url"
            case title
            case body
            case thumbnail
        }
        let id: Int
        let type: NewsType
        let urlString: String
        let title: String
        let body: String?
        let thumbnail: String
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try container.decode(Int.self, forKey: .id)
            let typeString = try container.decode(String.self, forKey: .type)
            switch typeString {
            case "youtube":
                self.type = NewsType.youtube
            case "blog":
                self.type = NewsType.blog
            case "rumor":
                self.type = NewsType.rumor
            case "news":
                self.type = NewsType.news
            default:
                self.type = NewsType.misc
            }
            self.urlString = try container.decode(String.self, forKey: .urlString)
            self.title = try container.decode(String.self, forKey: .title)
            self.body = try container.decode(String?.self, forKey: .body)
            self.thumbnail = try container.decode(String.self, forKey: .thumbnail)
        }
    }
}

//MARK: - Mapping to Domain

extension NewsResultDTO {
    func toDomain() -> NewsResult {
        return .init(statusCode: statusCode,
                     title: title,
                     description: description,
                     count: count,
                     results: results.map { $0.toDomain() }
        )
    }
}

extension NewsResultDTO.NewsDTO {
    func toDomain() -> News {
        return .init(id: id,
                     type: type,
                     urlString: urlString,
                     title: title,
                     body: body,
                     thumbnail: thumbnail
        )
    }
}
